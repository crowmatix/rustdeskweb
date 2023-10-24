import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/model.dart';
import 'package:provider/provider.dart';

class SecurityPage extends StatefulWidget {
  SecurityPage({Key? key}) : super(key: key);

  final appBarActions = <Widget>[SecMenu()];

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SecMenu extends StatefulWidget {
  @override
  State<SecMenu> createState() => _SecMenuState();
}

class _SecMenuState extends State<SecMenu> {
  final redColor = Color.fromARGB(255, 247, 83, 72);
  final greenColor = Color.fromARGB(255, 128, 240, 113);

  final webVersion = version;

  bool isSecOneEnabled = false;
  bool isSecTwoEnabled = false;
  bool isSecThreeEnabled = false;
  bool isSecFourEnabled = false;
  bool isSecFiveEnabled = false;
  bool isSecSixEnabled = false;
  bool isSecSevenEnabled = false;

  bool isSecurityEnabled = false;

  @override
  void initState() {
    _isSecSevenCheck();

    _startSecurityPeriod();
    super.initState();
  }

  void _startSecurityPeriod() {
    //Jede Sekunde
    Timer.periodic(Duration(seconds: 1), (timer) {
      // checken, ob Key sicher ist
      _isSecTwoCheck();

      // checken, ob OverAllSsecurity false ist
      _isSecurityEnabledCheck();
    });
  }

  void _isSecTwoCheck() {
    final key = FFI.getByName('option', 'key');

    if (key == '') {
      isSecTwoEnabled = false;
    } else {
      if (_isKeySecure(key)) {
        isSecTwoEnabled = true;
      } else {
        isSecTwoEnabled = false;
      }
    }
  }

  void _isSecSevenCheck() {
    if (getNewestWebVersion() == webVersion) {
      isSecSevenEnabled = true;
    } else {
      isSecSevenEnabled = false;
    }
  }

  void _isSecurityEnabledCheck() {
    isSecurityEnabled = isSecOneEnabled &&
        isSecTwoEnabled &&
        isSecThreeEnabled &&
        isSecFourEnabled &&
        isSecFiveEnabled &&
        isSecSixEnabled &&
        isSecSevenEnabled;
  }

  void showSecTwo() {
    final key = FFI.getByName('option', 'key');

    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Sichere Verschlüsselungsverfahren'),
                Icon(
                  Icons.circle,
                  color: isSecTwoEnabled ? greenColor : redColor,
                ), // Text
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
          ],
        ),
        content: Wrap(direction: Axis.vertical, spacing: 12, children: [
          Text('Eingegebener Key:\n$key'),
          InkWell(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Sicherheitsanalyse:',
            ),
          )),
        ]),
        actions: [],
      );
    }, clickMaskDismiss: true, backDismiss: true);
  }

  void showSecSeven() {
    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Regelmäßige Updates'),
                Icon(
                  Icons.circle,
                  color: isSecSevenEnabled ? greenColor : redColor,
                ), // Text
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
          ],
        ),
        content: Wrap(direction: Axis.vertical, spacing: 12, children: [
          Text('Aktuelle Version: $webVersion'),
          InkWell(
              onTap: () async {
                if (webVersion != getNewestWebVersion()) {
                  // UPDATE Möglichkeit
                  debugPrint("z.B. auf Seite weiterleiten");
                } else {
                  debugPrint("Passt");
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Neueste Version: ' + getNewestWebVersion(),
                ),
              )),
        ]),
        actions: [],
      );
    }, clickMaskDismiss: true, backDismiss: true);
  }

  String getNewestWebVersion() {
    // PLATZHALTER
    return '1.1.10';
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FfiModel>(context);
    return PopupMenuButton<String>(
        icon: Icon(
          Icons.security,
          color: isSecurityEnabled ? greenColor : redColor,
        ),
        itemBuilder: (context) {
          return ([
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Sichere Protokolle'),
                      Icon(Icons.circle,
                          color:
                              isSecOneEnabled ? greenColor : redColor), // Text
                    ],
                  ),
                  value: "sec1",
                )
              ] +
              [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Text('Sichere Verschlüsselungsverfahren')),
                      Icon(
                        Icons.circle,
                        color: isSecTwoEnabled ? greenColor : redColor,
                      ), // Text
                    ],
                  ),
                  value: "sec2",
                )
              ] +
              [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Privates Netz'),
                      Icon(
                        Icons.circle,
                        color: isSecThreeEnabled ? greenColor : redColor,
                      ), // Text
                    ],
                  ),
                  value: "sec3",
                )
              ] +
              [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Logging der Sitzung'),
                      Icon(
                        Icons.circle,
                        color: isSecFourEnabled ? greenColor : redColor,
                      ), // Text
                    ],
                  ),
                  value: "sec4",
                )
              ] +
              [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Unterbrechung bei Inaktivität'),
                      Icon(
                        Icons.circle,
                        color: isSecFiveEnabled ? greenColor : redColor,
                      ), // Text
                    ],
                  ),
                  value: "sec5",
                )
              ] +
              [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Bildschirmaufzeichnung'),
                      Icon(
                        Icons.circle,
                        color: isSecSixEnabled ? greenColor : redColor,
                      ), // Text
                    ],
                  ),
                  value: "sec6",
                )
              ] +
              [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Updates'),
                      Icon(
                        Icons.circle,
                        color: isSecSevenEnabled ? greenColor : redColor,
                      ), // Text
                    ],
                  ),
                  value: "sec7",
                )
              ]);
        },
        onSelected: (value) {
          if (value == 'sec1') {
            // Passiert X
            debugPrint(value);
          }
          if (value == 'sec2') {
            // Passiert Y
            showSecTwo();
          }
          if (value == 'sec3') {
            // Passiert Z
            debugPrint(value);
          }
          if (value == 'sec4') {
            // Passiert Z
            debugPrint(value);
          }
          if (value == 'sec5') {
            // Passiert Z
            debugPrint(value);
          }
          if (value == 'sec6') {
            // Passiert Z
            debugPrint(value);
          }
          if (value == 'sec7') {
            showSecSeven();
          }
        });
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

  bool result = entropy >= 3 ? true : false;

  return result;
}
