import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/model.dart';
import 'package:provider/provider.dart';

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
            debugPrint(value);
          }
          if (value == 'sec6') {
            debugPrint(value);
          }
          if (value == 'sec7') {
            showSecSeven(provider.seventhSecReq);
          }
        });
  }

  void showSecTwo(bool second) {
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

  void showSecFour(bool four) {
    final provider = Provider.of<SecurityProvider>(context, listen: false);

    DialogManager.show((setState, close) {
      return CustomAlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Logging der Sitzung'),
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
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Wollen Sie die Fernwartungsessions loggen?'),
                  Switch(
                    // This bool value toggles the switch.
                    value: four,
                    activeColor: Colors.grey,
                    onChanged: (bool? newValue) {
                      setState(() {
                        four = newValue!;
                        // Security Model Change -> secondSecReq change
                        provider.changeFourthSecReq();
                      });
                    },
                  )
                ]),
            SingleChildScrollView(child: provider.loggingData),
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
                Text('Regelmäßige Updates'),
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
}
