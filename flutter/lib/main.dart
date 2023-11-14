import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'models/model.dart';
import 'models/security_model.dart';
import 'pages/home_page.dart';
import 'pages/server_page.dart';
import 'pages/settings_page.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FFI.ffiModel.init();
  refreshCurrentUser();
  toAndroidChannelInit();
  FFI.setByName('option',
      '{"name": "custom-rendezvous-server", "value": "192.168.171.12"}');
  FFI.setByName(
      'option', '{"name": "relay-server", "value": "192.168.171.12"}');
  FFI.setByName('option',
      '{"name": "key", "value": "O0SgOk3IACtZeHHqAFHZzB7RDEX+Q8n9xw1hArqH33U="}');
  FFI.setByName('option', '{"name": "api-server", "value": ""}');
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: FFI.ffiModel),
        ChangeNotifierProvider.value(value: FFI.imageModel),
        ChangeNotifierProvider.value(value: FFI.cursorModel),
        ChangeNotifierProvider.value(value: FFI.canvasModel),
        ChangeNotifierProvider(
          create: (context) => SecurityProvider(),
        ),
      ],
      child: MaterialApp(
          initialRoute: '/',
          routes: {},
          onGenerateRoute: (settings) {
            // // If you push the PassArguments route
            var connectUrlActive =
                settings.name?.startsWith(PassArgumentsScreen.routeName);
            connectUrlActive = connectUrlActive == null ? false : true;

            if (connectUrlActive) {
              var uriData = Uri.parse(settings.name!);
              var queryParams = uriData.queryParameters;
              return MaterialPageRoute(
                builder: (context) {
                  return PassArgumentsScreen(queryParams);
                },
              );
            }
            return null;
          },
          navigatorKey: globalKey,
          debugShowCheckedModeBanner: false,
          title: 'RustDesk',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: !isAndroid ? WebHomePage() : HomePage(),
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(
              builder: isAndroid
                  ? (_, child) => AccessibilityListener(
                        child: child,
                      )
                  : null)),
    );
  }
}
