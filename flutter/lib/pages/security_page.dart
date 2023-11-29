import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/model.dart';
import 'package:provider/provider.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:url_launcher/url_launcher.dart';
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

class SecMenuState extends State<SecMenu> with TickerProviderStateMixin {
  final redColor = Color.fromARGB(255, 247, 83, 72);
  final greenColor = Color.fromARGB(255, 128, 240, 113);

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<SecurityProvider>(context, listen: false);
    if (!provider.inSession) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTabsDialog();
      });
    }
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
                      Text('Protokolle'),
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
                      Expanded(child: Text('Verschlüsselungsverfahren')),
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
                      Text('Netzwerkverbindung'),
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
            showSecOne(provider.firstSecReq);
          }
          if (value == 'sec2') {
            showSecTwo(provider.secondSecReq);
          }
          if (value == 'sec3') {
            showSecThree(provider.thirdSecReq);
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

  void showSecOne(bool one) {
    final provider = Provider.of<SecurityProvider>(context, listen: false);

    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Protokolle', textAlign: TextAlign.start)),
                InkWell(
                  onTap: () {
                    _showInfoBox(1);
                  },
                  child: Icon(
                    Icons
                        .question_mark, // Verwende ein anderes Icon deiner Wahl
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  color: one ? greenColor : redColor,
                ), // Text
              ],
            ),
            Divider(color: Colors.black, thickness: 0.5),
          ],
        ),
        content: Wrap(direction: Axis.vertical, spacing: 12, children: [
          Text('Die Prüfung hat ergeben:'),
          Container(
            color: provider.protocol == "https" ? Colors.green : Colors.red,
            child: Text(
              provider.protocol == "https"
                  ? 'Es wird HTTPS als Protokoll benutzt'
                  : 'Es wird nur HTTP als Protokoll benutzt',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]),
        actions: [],
      );
    }, clickMaskDismiss: true, backDismiss: true);
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
                  child: Text('Verschlüsselungsverfahren',
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
            Divider(color: Colors.black, thickness: 0.5),
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
                  text: '\nGrün',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                TextSpan(
                  text:
                      ': 1. Key vorhanden 2. Über 32 Zeichen lang. 3. Entropie über vier. 4. Nicht im commonDictionary',
                ),
                TextSpan(
                  text: '\nOrange',
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                TextSpan(
                  text:
                      ': 1. Key vorhanden 2. Über 16 Zeichen lang. 3. Entropie über drei. 4. Nicht im commonDictionary',
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

  void showSecThree(bool three) {
    final provider = Provider.of<SecurityProvider>(context, listen: false);

    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child:
                        Text('Netzwerkverbindung', textAlign: TextAlign.start)),
                InkWell(
                  onTap: () {
                    _showInfoBox(3);
                  },
                  child: Icon(
                    Icons
                        .question_mark, // Verwende ein anderes Icon deiner Wahl
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  color: three ? greenColor : redColor,
                ), // Text
              ],
            ),
            Divider(color: Colors.black, thickness: 0.5),
          ],
        ),
        content: Wrap(direction: Axis.vertical, spacing: 12, children: [
          Text('Erkennung der Netzwerkkonnektivität:'),
          SizedBox(
            height: 5,
          ),
          buildInkWell('Mobile', provider.network),
          buildInkWell('Wi-Fi', provider.network),
          buildInkWell('Ethernet', provider.network),
          buildInkWell('VPN', provider.network),
          buildInkWell('Other', provider.network),
          buildInkWell('None', provider.network),
        ]),
        actions: [],
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
                        provider.convertToCSV();
                      });
                    },
                    child: Icon(
                        Icons.save_alt // Verwende ein anderes Icon deiner Wahl
                        )),
                SizedBox(width: 10),
                InkWell(
                    onTap: () {
                      setState(() {
                        provider.inSession = false;
                      });
                    },
                    child: Icon(Icons
                            .replay_outlined // Verwende ein anderes Icon deiner Wahl
                        )),
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
            Divider(color: Colors.black, thickness: 0.5),
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
                ]),
            Divider(color: Colors.black, thickness: 0.5),
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
            Divider(color: Colors.black, thickness: 0.5),
          ],
        ),
        content: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Aufnahme des Bildschirms starten?'),
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
                      // Security Model Change -> SixSecReq change
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
            Divider(color: Colors.black, thickness: 0.5),
          ],
        ),
        content: Wrap(direction: Axis.vertical, spacing: 12, children: [
          Text('Aktuelle Version: $version'),
          InkWell(
              onTap: () {
                if (version != newestWebVersion) {
                  _launchURL();
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

  Widget buildInkWell(String text, String networkType) {
    return InkWell(
        child: Row(children: [
      Text(text),
      SizedBox(width: 40),
      if (text == networkType) Icon(Icons.check),
    ]));
  }

  void _showInfoBox(int sec) {
    String title;
    String content;
    if (sec == 1) {
      title = 'Anforderung: Protokolle';
      content =
          'Schützen Sie Ihre Daten mit sicheren Protokollen. Der WebClient von RustDesk sollte im Normalfall HTTPS verwenden, um eine verschlüsselte Kommunikation zu gewährleisten. Vermeiden Sie die Verwendung von ungesicherten HTTP-Verbindungen für eine zuverlässige und sichere Interaktion bei Fernwartungen.';
    } else if (sec == 2) {
      title = 'Anforderung: Verschlüsselung';
      content =
          'Schützen Sie Ihre Verbindung mit starken Verschlüsselungsverfahren. In RustDesk ist es möglich einen SSH-Key des Rust Desk Servers einzugeben, für eine sichere Kommunikation zwischen dem WebClient und dem RustDesk Server. Gewährleisten Sie so einen geschützten Datenaustausch.';
    } else if (sec == 3) {
      title = 'Anforderung: Netzwerkverbindung';
      content =
          'Es wird die Art der Netzwerkverbindung identifiziert. RustDesk unterscheidet automatisch mobile (cellular), Ethernet und VPN-Verbindungen als sicher. Beachten Sie, dass Wi-Fi-Verbindungen generell als unsicher gelten, jedoch bei privaten Wi-Fi-Netzwerken sicher sein können. Optimieren Sie Ihre Einstellungen basierend auf dieser Unterscheidung für eine effiziente und sichere Fernwartung.';
    } else if (sec == 4) {
      title = 'Anforderung: Logging';
      content =
          'Loggen Sie ausgehende Fernwartungsitzungen. RustDesk zeichnet die Uhrzeit, Sitzungsdauer und Geräteinformationen des Peers auf. Downloaden Sie Logs für eine umfassende Historie Ihrer Fernwartungssitzungen.';
    } else if (sec == 5) {
      title = 'Anforderung: Inaktivität';
      content =
          'Verhindern Sie unbefugten Zugriff bei Inaktivität. RustDesk integriert einen Timer, der bei fehlenden Aktionen abläuft. So wird die Fernwartung sicher unterbrochen.';
    } else if (sec == 6) {
      title = 'Anforderung: Aufzeichnung';
      content =
          'Erfassen Sie wichtige Momente Ihrer Fernwartung. RustDesk ermöglicht die Bildschirmaufzeichnung, die sicher im Browser gespeichert wird. Halten Sie wichtige Details für spätere Überprüfungen fest.';
    } else {
      title = 'Anforderung: Updates';
      content =
          'Halten Sie Ihren WebClient auf dem neuesten Stand. RustDesk überprüft automatisch Versionen für Updates. Vergleichen Sie WebClient-Versionen, um von den neuesten Funktionen und Sicherheitsverbesserungen zu profitieren.';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Container(width: 125, child: Text(content)),
            actions: <Widget>[],
          );
        });
  }

  void _showTabsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(children: [
              Text('Sicherheitsanforderungen', textAlign: TextAlign.center),
              SizedBox(width: 20),
              Icon(
                Icons.security,
                color: Provider.of<SecurityProvider>(context).overallSecurity
                    ? greenColor
                    : redColor,
              ),
            ]),
            content: Container(
              width: double.maxFinite,
              height: 325,
              child: DefaultTabController(
                length: 7,
                child: Column(
                  children: [
                    Divider(color: Colors.black, thickness: 0.5),
                    TabBar(
                      labelColor: Colors.black, // Farbe für aktive Tabschrift
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Protokolle'),
                        Tab(text: 'Verschlüsselung'),
                        Tab(text: 'Netzwerkverbindung'),
                        Tab(text: 'Logging'),
                        Tab(text: 'Inaktivität'),
                        Tab(text: 'Aufzeichnung'),
                        Tab(text: 'Updates'),
                      ],
                    ),
                    Divider(color: Colors.black, thickness: 0.5),
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildDialogContentOne(),
                          buildDialogContentTwo(),
                          buildDialogContentThree(),
                          buildDialogContentFour(),
                          buildDialogContentFive(),
                          buildDialogContentSix(),
                          buildDialogContentSeven(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Schließen'),
              )),
            ]);
      },
    );
  }

  Widget buildDialogContentOne() {
    final provider = Provider.of<SecurityProvider>(context, listen: false);
    return Column(children: [
      SizedBox(height: 20),
      Text(
          'Schützen Sie Ihre Daten mit sicheren Protokollen. Der WebClient von RustDesk sollte im Normalfall HTTPS verwenden, um eine verschlüsselte Kommunikation zu gewährleisten. Vermeiden Sie die Verwendung von ungesicherten HTTP-Verbindungen für eine zuverlässige und sichere Interaktion bei Fernwartungen.'),
      SizedBox(height: 20),
      Text('Die Prüfung hat ergeben:'),
      SizedBox(height: 10),
      Container(
          color: provider.protocol == "https" ? greenColor : redColor,
          child: Text(
            provider.protocol == "https"
                ? 'Es wird HTTPS als Protokoll benutzt'
                : 'Es wird nur HTTP als Protokoll benutzt',
            style: TextStyle(color: Colors.white),
          )),

      // Zertifikatsanalyse !!!
    ]);
  }

  Widget buildDialogContentTwo() {
    final provider = Provider.of<SecurityProvider>(context, listen: false);
    final key = FFI.getByName('option', 'key');
    return Column(children: [
      SizedBox(height: 20),
      Text(
          'Schützen Sie Ihre Verbindung mit starken Verschlüsselungsverfahren. In RustDesk ist es möglich einen SSH-Key des Rust Desk Servers einzugeben, für eine sichere Kommunikation zwischen dem WebClient und dem RustDesk Server. Gewährleisten Sie so einen geschützten Datenaustausch.'),
      SizedBox(height: 20),
      Text('Eingegebener Key:'),
      SizedBox(height: 10),
      Container(
          color: provider.secondSecReq ? greenColor : redColor,
          child: Text(
            '$key',
            style: TextStyle(color: Colors.white),
          )),
    ]);
  }

  Widget buildDialogContentThree() {
    final provider = Provider.of<SecurityProvider>(context, listen: false);
    String network = provider.network;
    return Column(children: [
      SizedBox(height: 20),
      Text(
          'Es wird die Art der Netzwerkverbindung identifiziert. RustDesk unterscheidet automatisch mobile (cellular), Ethernet und VPN-Verbindungen als sicher. Beachten Sie, dass Wi-Fi-Verbindungen generell als unsicher gelten, jedoch bei privaten Wi-Fi-Netzwerken sicher sein können. Optimieren Sie Ihre Einstellungen basierend auf dieser Unterscheidung für eine effiziente und sichere Fernwartung.'),
      SizedBox(height: 20),
      Text('Die Prüfung hat ergeben:'),
      SizedBox(height: 10),
      Container(
          color: provider.thirdSecReq ? greenColor : redColor,
          child: Text(
            '$network',
            style: TextStyle(color: Colors.white),
          )),
    ]);
  }

  Widget buildDialogContentFour() {
    final provider = Provider.of<SecurityProvider>(context, listen: false);
    return Column(children: [
      SizedBox(height: 20),
      Text(
          'Loggen Sie ausgehende Fernwartungsitzungen. RustDesk zeichnet die Uhrzeit, Sitzungsdauer und Geräteinformationen des Peers auf. Downloaden Sie Logs für eine umfassende Historie Ihrer Fernwartungssitzungen.'),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Text('Wollen Sie die Fernwartungsessions loggen?'),
        Switch(
          // This bool value toggles the switch.
          value: provider.fourthSecReq,
          activeColor: greenColor,
          onChanged: (bool? newValue) {
            provider.changeFourthSecReq(newValue!);
          },
        ),
      ]),
    ]);
  }

  Widget buildDialogContentFive() {
    final provider = Provider.of<SecurityProvider>(context, listen: false);
    return Column(children: [
      SizedBox(height: 20),
      Text(
          'Verhindern Sie unbefugten Zugriff bei Inaktivität. RustDesk integriert einen Timer, der bei fehlenden Aktionen abläuft. So wird die Fernwartung sicher unterbrochen, standardmäßig sind 60 sek eingestellt. Dies kann über das Security Menü speziell eingestellt werden.'),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Text('Wollen Sie die Fernwartung bei Inaktivität unterbrechen?'),
        Switch(
          // This bool value toggles the switch.
          value: provider.fifthSecReq,
          activeColor: greenColor,
          onChanged: (bool? newValue) {
            provider.changeFifthSecReq(newValue!);
          },
        ),
      ]),
    ]);
  }

  Widget buildDialogContentSix() {
    return Column(children: [
      SizedBox(height: 20),
      Text(
          'Erfassen Sie wichtige Momente Ihrer Fernwartung. Der WebClient von RustDesk ermöglicht die Bildschirmaufzeichnung, die sicher im Browser gespeichert wird. Halten Sie wichtige Details für spätere Überprüfungen fest, indem sie über den Schalter des Security Menü Item "Bildschirmaufzeichnung" die Aufzeichnung starten und stoppen.'),
      SizedBox(height: 20),
    ]);
  }

  Widget buildDialogContentSeven() {
    final provider = Provider.of<SecurityProvider>(context, listen: false);
    return Column(children: [
      SizedBox(height: 20),
      Text(
          'Halten Sie Ihren WebClient auf dem neuesten Stand. RustDesk überprüft automatisch Versionen für Updates. Vergleichen Sie WebClient-Versionen, um von den neuesten Funktionen und Sicherheitsverbesserungen zu profitieren.'),
      SizedBox(height: 20),
      Container(
          color: provider.secondSecReq ? greenColor : redColor,
          child: Text(
            'Aktuelle Version: $version',
            style: TextStyle(color: Colors.white),
          )),
      SizedBox(height: 10),
      InkWell(
          onTap: () {
            if (version != newestWebVersion) {
              _launchURL();
            }
          },
          child: Text(
            'Neueste Version: $newestWebVersion',
          )),
    ]);
  }

  void _launchURL() async {
    final httpsUri = Uri(
        scheme: 'https', host: 'rustdesk.com', path: 'docs/de/dev/build/web/');

    if (await canLaunchUrl(httpsUri)) {
      await launchUrl(httpsUri);
    } else {
      throw 'Konnte die Internetseite nicht öffnen: $httpsUri';
    }
  }
}
