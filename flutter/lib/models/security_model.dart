import 'dart:math';
import 'dart:html';
import 'dart:js';
import 'dart:js_util' as js_util;
import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/model.dart';
import 'package:flutter_hbb/pages/security_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

class SecurityProvider extends ChangeNotifier {
  bool firstSecReq;
  bool secondSecReq;
  bool thirdSecReq;
  bool fourthSecReq;
  bool fifthSecReq;
  bool sixthSecReq;
  bool seventhSecReq;

  late bool overallSecurity;

  bool inSession = false;
  late DataTable loggingData = createDataTable();
  late DateTime sessionStartTime;

  late int inactiveTime;

  SecurityProvider({
    this.firstSecReq = false,
    this.secondSecReq = false,
    this.thirdSecReq = false,
    this.fourthSecReq = false,
    this.fifthSecReq = false,
    this.sixthSecReq = false,
    this.seventhSecReq = false,
    this.overallSecurity = false,
  });

  Future<void> startCapture() async {
    context.callMethod('startCapture');
  }

  Future<void> stopCapture() async {
    context.callMethod('stopCapture');
  }

  Future<void> requirementsCheck() async {
    isSecTwoCheck();
    //isSecThreeCheck();
    await isSecFourCheck();
    await isSecFiveCheck();
    await isSecSixCheck();
    isSecSevenCheck();

    isOverAllSecurityCheck();
  }

  void isSecTwoCheck() {
    final key = FFI.getByName('option', 'key');

    if (key == '' || !_isKeySecure(key)) {
      changeSecondSecReq(false);
    } else {
      changeSecondSecReq(true);
    }
  }

  //Future<void> isSecThreeCheck() async {}

  Future<void> isSecFourCheck() async {
    // PERSISTENTE SPEICHERUNG checken und ggf ändern
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? reqFour = prefs.getBool('reqFour');
    if (reqFour != null) {
      fourthSecReq = reqFour;
    }
    getSavedLogs();
  }

  Future<void> isSecFiveCheck() async {
    // PERSISTENTE SPEICHERUNG checken und ggf ändern
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? reqFive = prefs.getBool('reqFive');
    if (reqFive != null) {
      fifthSecReq = reqFive;
    }

    int? savedInactiveTime = prefs.getInt('inactive');
    if (savedInactiveTime != null) {
      inactiveTime = savedInactiveTime;
    } else {
      inactiveTime = 60;
    }
  }

  Future<void> isSecSixCheck() async {
    // PERSISTENTE SPEICHERUNG checken und ggf ändern
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? reqSix = prefs.getBool('reqSix');
    if (reqSix != null) {
      sixthSecReq = reqSix;
    }
  }

  void isSecSevenCheck() {
    if (newestWebVersion != version) {
      changeSeventhSecReq(false);
    } else {
      changeSeventhSecReq(true);
    }
  }

  void isOverAllSecurityCheck() {
    if (firstSecReq &&
        secondSecReq &&
        thirdSecReq &&
        fourthSecReq &&
        fifthSecReq &&
        sixthSecReq &&
        seventhSecReq &&
        seventhSecReq) {
      overallSecurity = true;
    } else {
      overallSecurity = false;
    }
    notifyListeners();
  }

  void changeSecondSecReq(bool b) {
    secondSecReq = b;
  }

  Future<void> changeFourthSecReq(bool b) async {
    fourthSecReq = b;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('reqFour', b);
  }

  Future<void> changeFifthSecReq(bool b) async {
    fifthSecReq = b;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('reqFive', b);
  }

  Future<void> changeSixthSecReq(bool b) async {
    sixthSecReq = b;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('reqSix', b);
  }

  void changeSeventhSecReq(bool b) {
    seventhSecReq = b;
  }

  void changeInSession(bool b) {
    inSession = b;
  }

  Future<void> changeInactiveTime(int s) async {
    inactiveTime = s;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('inactive', s);
  }

  DataTable createDataTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Fernwartungs ID')),
        DataColumn(label: Text('Startzeit')),
        DataColumn(label: Text('Länge')),
      ],
      rows: [],
    );
  }

  Future<void> addInitalRow(String id) async {
    sessionStartTime = DateTime.now();
    final timeNow = DateTime.now();

    String formattedTime =
        "${timeNow.day}.${timeNow.month}.${timeNow.year} - ${timeNow.hour}:";

    formattedTime += addZeroToString(timeNow.minute, true) + ':';
    formattedTime += addZeroToString(timeNow.second, false);

    final newRow = DataRow(cells: [
      DataCell(Text(id)),
      DataCell(Text(formattedTime)),
      DataCell(Text('-')),
    ]);
    // Erstelle eine Kopie der aktuellen DataTable-Rows und füge die neue Row hinzu.
    final List<DataRow> currentRows = List.from(loggingData.rows);
    currentRows.add(newRow);

    // Aktualisiere die DataTable mit den neuen Rows.
    loggingData = DataTable(
      columns: loggingData.columns,
      rows: currentRows,
    );

    // PERSISTENT ABSPEICHERN
    List<String> dataAsStringList = [];

    for (DataRow row in loggingData.rows) {
      for (DataCell cell in row.cells) {
        String? cellContent = (cell.child as Text).data;
        dataAsStringList.add(cellContent!);
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('loggingData', dataAsStringList);
  }

  Future<void> addSessionLength() async {
    final timeNow = DateTime.now();
    final difference = timeNow.difference(sessionStartTime);

    String formattedTime = '';
    formattedTime += addZeroToString(difference.inMinutes, true) + ' min ';
    formattedTime += addZeroToString(difference.inSeconds % 60, false) + ' sec';

    final List<DataRow> currentRows = List.from(loggingData.rows);
    final DataRow lastRow = currentRows.last;

    // Aktualisiere die letzte DataCell in der letzten Zeile
    final List<DataCell> cells = List.from(lastRow.cells);
    cells[2] = DataCell(Text(formattedTime));

    // Aktualisiere die letzte Zeile mit den aktualisierten DataCells
    currentRows[currentRows.length - 1] = DataRow(cells: cells);

    // Aktualisiere das DataTable
    loggingData = DataTable(
      columns: loggingData.columns,
      rows: currentRows,
    );

    // PERSISTENT ABSPEICHERN
    List<String> dataAsStringList = [];

    for (DataRow row in loggingData.rows) {
      for (DataCell cell in row.cells) {
        String? cellContent = (cell.child as Text).data;
        dataAsStringList.add(cellContent!);
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('loggingData', dataAsStringList);
  }

  Future<void> getSavedLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dataAsStringList = prefs.getStringList('loggingData');

    if (dataAsStringList != null) {
      List<DataRow> savedRows = [];

      for (int i = 0; i < dataAsStringList.length; i += 3) {
        if (i + 2 < dataAsStringList.length) {
          DataRow newRow = DataRow(cells: [
            DataCell(Text(dataAsStringList[i])),
            DataCell(Text(dataAsStringList[i + 1])),
            DataCell(Text(dataAsStringList[i + 2])),
          ]);

          savedRows.add(newRow);
        }
      }
      loggingData = DataTable(
        columns: loggingData.columns,
        rows: savedRows,
      );
    }
  }

  String addZeroToString(int digit, bool minute) {
    if (minute) {
      if (digit < 10)
        return '0${digit}';
      else
        return '${digit}';
    } else {
      if (digit < 10)
        return '0${digit}';
      else
        return '${digit}';
    }
  }

  bool _isKeySecure(String key) {
    final entropy = _isKeyRandom(key);
    if (key.isNotEmpty &&
        key.length >= 32 &&
        entropy > 4 &&
        !commonDictionary.containsKey(key)) {
      return true;
    }
    return false;
  }
}

double _isKeyRandom(String key) {
  Map<String, int> map = {};

  for (int i = 0; i < key.length; i++) {
    String c = key[i];
    if (!map.containsKey(c)) {
      map[c] = 1;
    } else {
      map[c] = map[c]! + 1;
    }
  }

  double entropy = 0.0;
  int len = key.length;

  map.forEach((key, value) {
    double frequency = value / len;
    entropy -= frequency * (log(frequency) / log(2));
  });
  return entropy;
}

enum CustomPassStrength implements PasswordStrengthItem {
  weak,
  medium,
  strong;

  @override
  Color get statusColor {
    switch (this) {
      case CustomPassStrength.weak:
        return Colors.red;
      case CustomPassStrength.medium:
        return Colors.orange;
      case CustomPassStrength.strong:
        return Colors.green;
    }
  }

  @override
  Widget? get statusWidget {
    switch (this) {
      case CustomPassStrength.weak:
        return const Text('Weak');
      case CustomPassStrength.medium:
        return const Text('Medium');
      case CustomPassStrength.strong:
        return const Text('Strong');
      default:
        return null;
    }
  }

  @override
  double get widthPerc {
    switch (this) {
      case CustomPassStrength.weak:
        return 0.25;
      case CustomPassStrength.medium:
        return 0.5;
      case CustomPassStrength.strong:
        return 1;
      default:
        return 0.0;
    }
  }

  static CustomPassStrength? calculate({required String text}) {
    final entropy = _isKeyRandom(text);

    if (text.isNotEmpty &&
        !commonDictionary.containsKey(text) &&
        text.length > 32 &&
        entropy > 4) {
      return CustomPassStrength.strong;
    } else if (text.isNotEmpty &&
        !commonDictionary.containsKey(text) &&
        text.length > 16 &&
        entropy > 3) {
      return CustomPassStrength.medium;
    } else {
      return CustomPassStrength.weak;
    }
  }
}
