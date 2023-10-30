import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/model.dart';
import 'package:flutter_hbb/pages/security_page.dart';

class SecurityProvider extends ChangeNotifier {
  bool firstSecReq;
  bool secondSecReq;
  bool thirdSecReq;
  bool fourthSecReq;
  bool fifthSecReq;
  bool sixthSecReq;
  bool seventhSecReq;

  bool overallSecurity;

  bool inSession = false;
  late DataTable loggingData = createDataTable();
  late DateTime sessionStartTime;

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

  void changeFourthSecReq() {
    fourthSecReq = !fourthSecReq;
    isOverAllSecurityCheck();
  }

  void isSecTwoCheck() {
    final key = FFI.getByName('option', 'key');

    if (key == '' || !_isKeySecure(key)) {
      secondSecReq = false;
    } else {
      secondSecReq = true;
    }
    isOverAllSecurityCheck();
  }

  void isSecSevenCheck() {
    if (newestWebVersion != version) {
      seventhSecReq = false;
    } else {
      seventhSecReq = true;
    }
    isOverAllSecurityCheck();
  }

  void isOverAllSecurityCheck() {
    overallSecurity = firstSecReq &&
        secondSecReq &&
        thirdSecReq &&
        fourthSecReq &&
        fifthSecReq &&
        sixthSecReq &&
        seventhSecReq &&
        seventhSecReq;
  }

  void requirementsCheck() {
    isSecTwoCheck();
    isSecSevenCheck();

    isOverAllSecurityCheck();
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

  void addInitalRow(String id) {
    sessionStartTime = DateTime.now();
    final timeNow = DateTime.now();

    var formattedTime =
        "${timeNow.day}.${timeNow.month}.${timeNow.year} - ${timeNow.hour}:";

    if (timeNow.minute < 10)
      formattedTime += "0${timeNow.minute}:";
    else
      formattedTime += "${timeNow.minute}:";

    if (timeNow.second < 10)
      formattedTime += "0${timeNow.second}";
    else
      formattedTime += "${timeNow.second}";

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
    //notifyListeners(); // Informiere die Widgets über die Änderung der Daten.
  }

  void addSessionLength() {
    final timeNow = DateTime.now();
    final difference = timeNow.difference(sessionStartTime);

    String formattedTime = '';
    if (difference.inMinutes < 10)
      formattedTime += '0${difference.inMinutes} min ';
    else
      formattedTime += '${difference.inMinutes} min ';

    if (difference.inSeconds < 10)
      formattedTime += '0${difference.inSeconds % 60} sec';
    else
      formattedTime += '${difference.inSeconds % 60} sec';

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
  }
}

bool _isKeySecure(String key) {
  final minKeyLength = 32;

  if (key.length >= minKeyLength && _isKeyRandom(key)) {
    return true;
  }
  return false;
}

bool _isKeyRandom(String key) {
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

  bool result = entropy >= 4 ? true : false;

  return result;
}
