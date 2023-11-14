import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/model.dart';
import 'package:provider/provider.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import '../models/security_model.dart';

//PLATZHALTER
final newestWebVersion = '1.1.10';

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
  SecMenu({Key? key}) : super(key: key);

  @override
  State<SecMenu> createState() => SecMenuState();
}

class SecMenuState extends State<SecMenu> {
  final redColor = Color.fromARGB(255, 247, 83, 72);
  final greenColor = Color.fromARGB(255, 128, 240, 113);

  final TextEditingController _textEditingController = TextEditingController();

  //bool recording = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SecurityProvider>(context, listen: false);

    return PopupMenuButton<String>(
        icon: Icon(
          Icons.security,
          color: Provider.of<SecurityProvider>(context).overallSecurity
              ? greenColor
              : redColor,
        ),
        itemBuilder: (context) {
          return ([
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Sichere Protokolle'),
                      Icon(Icons.circle,
                          color: provider.firstSecReq
                              ? greenColor
                              : redColor), // Text
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
                        color: provider.secondSecReq ? greenColor : redColor,
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
                        color: provider.thirdSecReq ? greenColor : redColor,
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
                        color: provider.fourthSecReq ? greenColor : redColor,
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
                        color: provider.fifthSecReq ? greenColor : redColor,
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
                        color: provider.sixthSecReq ? greenColor : redColor,
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
                        color: provider.seventhSecReq ? greenColor : redColor,
                      ), // Text
                    ],
                  ),
                  value: "sec7",
                )
              ]);
        },
        onSelected: (value) {
          if (value == 'sec1') {
            debugPrint(value);
          }
          if (value == 'sec2') {
            showSecTwo(provider.secondSecReq);
          }
          if (value == 'sec3') {
            debugPrint(value);
          }
          if (value == 'sec4') {
            showSecFour(provider.fourthSecReq);
          }
          if (value == 'sec5') {
            showSecFive(provider.fifthSecReq);
          }
          if (value == 'sec6') {
            showSecSix(provider.sixthSecReq);
          }
          if (value == 'sec7') {
            showSecSeven(provider.seventhSecReq);
          }
        });
  }

  void showSecTwo(bool second) {
    final key = FFI.getByName('option', 'key');
    final passNotifier = ValueNotifier<CustomPassStrength?>(null);
    final passSecValue = CustomPassStrength.calculate(text: key);
    passNotifier.value = passSecValue;

    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text('Sichere Verschlüsselungsverfahren',
                      textAlign: TextAlign.start),
                ),
                InkWell(
                  onTap: () {
                    _showInfoBox(2);
                  },
                  child: Icon(
                    Icons
                        .question_mark, // Verwende ein anderes Icon deiner Wahl
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  color: second ? greenColor : redColor,
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
          RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 16, // Hier können Sie die Schriftgröße anpassen
                    height: 2, // Hier können Sie die Zeilenhöhe anpassen
                  ),
                  children: <InlineSpan>[
                TextSpan(
                  text: 'Eingegebener Key:\n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '$key',
                ),
                TextSpan(
                  text: '\nSicherheitsanalyse:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      '\n-- Hier muss noch eine Erklärung der Encryption Methode hin --',
                ),
                TextSpan(
                  text: '\nGrün',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                TextSpan(
                  text:
                      ': 1. Key nicht leer 2. Über 32 Zeichen lang. 3. Entropie über vier. 4. Nicht im commonDictionary',
                ),
                TextSpan(
                  text: '\nOrange',
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                TextSpan(
                  text:
                      ': 1. Key nicht leer 2. Über 16 Zeichen lang. 3. Entropie über drei. 4. Nicht im commonDictionary',
                ),
                TextSpan(
                  text: '\nRot',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                TextSpan(
                  text: ': Eins der 4 Kriterien nicht bestanden',
                ),
              ])),
        ]),
        actions: [
          PasswordStrengthChecker(
            strength: passNotifier,
          ),
        ],
      );
    }, clickMaskDismiss: true, backDismiss: true);
  }

  void showSecFour(bool four) {
    final provider = Provider.of<SecurityProvider>(context, listen: false);

    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text('Logging der Sitzung',
                        textAlign: TextAlign.start)),
                InkWell(
                  onTap: () {
                    setState(() {
                      provider.inSession = false;
                    });
                  },
                  child: Icon(
                    Icons
                        .replay_outlined, // Verwende ein anderes Icon deiner Wahl
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _showInfoBox(4);
                  },
                  child: Icon(
                    Icons
                        .question_mark, // Verwende ein anderes Icon deiner Wahl
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  color: four ? greenColor : redColor,
                ), // Text
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
          ],
        ),
        content: Column(
          children: [
            provider.inSession
                ? Text('In einer Session nicht resetten',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.start)
                : SizedBox(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Wollen Sie die Fernwartungsessions loggen?'),
                  Switch(
                    // This bool value toggles the switch.
                    value: four,
                    activeColor: Colors.grey,
                    onChanged: (bool? newValue) {
                      if (!provider.inSession) {
                        setState(() {
                          four = newValue!;
                        });
                        // Security Model Change -> secondSecReq change
                        provider.changeFourthSecReq(newValue!);
                      }
                    },
                  ),
                ]),
            SingleChildScrollView(child: provider.loggingData),
          ],
        ),
        actions: [],
      );
    }, clickMaskDismiss: true, backDismiss: true);
  }

  void showSecFive(bool five) {
    final provider = Provider.of<SecurityProvider>(context, listen: false);
    _textEditingController.text = provider.inactiveTime.toString();

    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text('Unterbrechung bei Inaktivität',
                        textAlign: TextAlign.start)),
                InkWell(
                  onTap: () {
                    _showInfoBox(5);
                  },
                  child: Icon(
                    Icons
                        .question_mark, // Verwende ein anderes Icon deiner Wahl
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  color: five ? greenColor : redColor,
                ), // Text
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
          ],
        ),
        content: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      'Wollen Sie die Fernwartung bei Inaktivität unterbrechen?'),
                  Switch(
                    // This bool value toggles the switch.
                    value: five,
                    activeColor: Colors.grey,
                    onChanged: (bool? newValue) {
                      //Wenn nicht in einer Session !
                      if (!provider.inSession) {
                        setState(() {
                          five = newValue!;
                        });
                        // Security Model Change -> fifthSecReq change
                        provider.changeFifthSecReq(newValue!);
                      }
                    },
                  ),
                ]),
            provider.inSession
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Wann soll die Sitzung abgebrochen werden?',
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        width: 50, // Setze hier die gewünschte Breite
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            labelText: 'sek',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            try {
                              int inactiveTimeInt = int.parse(value);
                              provider.changeInactiveTime(inactiveTimeInt);
                            } catch (e) {
                              //debugPrint("Kein Int am Start");
                              //Fehlermeldung anzeigen
                            }
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
        actions: [],
      );
    }, clickMaskDismiss: true, backDismiss: true);
  }

  void showSecSix(bool six) {
    final provider = Provider.of<SecurityProvider>(context, listen: false);

    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text('Bildschirmaufzeichnung',
                        textAlign: TextAlign.start)),
                InkWell(
                  onTap: () {
                    _showInfoBox(6);
                  },
                  child: Icon(
                    Icons
                        .question_mark, // Verwende ein anderes Icon deiner Wahl
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  color: six ? greenColor : redColor,
                ), // Text
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
          ],
        ),
        content: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Wollen Sie die Fernwartung aufzeichnen?'),
                  Switch(
                    // This bool value toggles the switch.
                    value: six,
                    activeColor: Colors.grey,
                    onChanged: (bool? newValue) {
                      if (newValue!) {
                        provider.startCapture();
                      } else {
                        provider.stopCapture();
                      }
                      setState(() {
                        six = newValue;
                      });
                      // Security Model Change -> secondSecReq change
                      provider.changeSixthSecReq(newValue);
                    },
                  ),
                ]),
          ],
        ),
        actions: [],
      );
    }, clickMaskDismiss: true, backDismiss: true);
  }

  void showSecSeven(bool seven) {
    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text('Regelmäßige Updates',
                        textAlign: TextAlign.start)),
                InkWell(
                  onTap: () {
                    _showInfoBox(7);
                  },
                  child: Icon(
                    Icons
                        .question_mark, // Verwende ein anderes Icon deiner Wahl
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  color: seven ? greenColor : redColor,
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
          Text('Aktuelle Version: $version'),
          InkWell(
              onTap: () async {
                if (version != newestWebVersion) {
                  // UPDATE Möglichkeit
                  debugPrint("z.B. auf Seite weiterleiten");
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Neueste Version: ' + newestWebVersion,
                ),
              )),
        ]),
        actions: [],
      );
    }, clickMaskDismiss: true, backDismiss: true);
  }

  void _showInfoBox(int sec) {
    String title;
    String content;
    if (sec == 1) {
      title = 'Anforderung: Protokolle';
      content = 'Hier ist der Inhalt für Anforderung $sec.';
    } else if (sec == 2) {
      title = 'Anforderung: Verschlüsslung';
      content = 'Hier ist der Inhalt für Anforderung $sec.';
    } else if (sec == 3) {
      title = 'Anforderung: Netz';
      content = 'Hier ist der Inhalt für Anforderung $sec.';
    } else if (sec == 4) {
      title = 'Anforderung: Logging';
      content = 'Hier ist der Inhalt für Anforderung $sec.';
    } else if (sec == 5) {
      title = 'Anforderung: Inaktivität';
      content = 'Hier ist der Inhalt für Anforderung $sec.';
    } else if (sec == 6) {
      title = 'Anforderung: Aufzeichnung';
      content = 'Hier ist der Inhalt für Anforderung $sec.';
    } else {
      title = 'Anforderung: Updates';
      content = 'Hier ist der Inhalt für Anforderung $sec.';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[],
        );
      },
    );
  }
}
