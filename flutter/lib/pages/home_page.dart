import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hbb/pages/chat_page.dart';
import 'package:flutter_hbb/pages/security_page.dart';
import 'package:flutter_hbb/pages/server_page.dart';
import 'package:flutter_hbb/pages/settings_page.dart';
import 'package:provider/provider.dart';
import '../common.dart';
import '../models/security_model.dart';
import '../widgets/overlay.dart';
import 'connection_page.dart';

abstract class PageShape extends Widget {
  final String title = "";
  final Icon icon = Icon(null);
  final List<Widget> appBarActions = [];
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;
  final List<PageShape> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(ConnectionPage());
    if (isAndroid) {
      _pages.addAll([chatPage, ServerPage()]);
    }
    _pages.add(SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
          } else {
            return true;
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: MyTheme.grayBg,
          appBar: AppBar(
            centerTitle: true,
            title: Text("RustDesk"),
            actions: _pages.elementAt(_selectedIndex).appBarActions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            key: navigationBarKey,
            items: _pages
                .map((page) =>
                    BottomNavigationBarItem(icon: page.icon, label: page.title))
                .toList(),
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: MyTheme.accent,
            unselectedItemColor: MyTheme.darkGray,
            onTap: (index) => setState(() {
              // close chat overlay when go chat page
              if (index == 1 && _selectedIndex != index) {
                hideChatIconOverlay();
                hideChatWindowOverlay();
              }
              _selectedIndex = index;
            }),
          ),
          body: _pages.elementAt(_selectedIndex),
        ));
  }
}

class WebHomePage extends StatelessWidget {
  final connectionPage = ConnectionPage();
  final securityPage = SecurityPage();

  List<Widget> combinedActions = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SecurityProvider>(context, listen: false);
    provider.requirementsCheck();

    var subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      changeConStatus(provider, result);
    });

    //Dieser isOverAllSecurityCheck Timer Check ist ein Workaroud und verhindert EXCEPTION durch notifyListeners
    Timer.periodic(Duration(milliseconds: 250), (timer) {
      provider.isOverAllSecurityCheck();
    });

    combinedActions.addAll(securityPage.appBarActions);
    combinedActions.add(SizedBox(width: 16));
    combinedActions.addAll(connectionPage.appBarActions);

    return Scaffold(
      backgroundColor: MyTheme.grayBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text("RustDesk" + (isWeb ? " (Beta) " : "")),
        actions: combinedActions,
      ),
      body: connectionPage,
    );
  }

  void changeConStatus(SecurityProvider provider, ConnectivityResult result) {
    if (result == ConnectivityResult.mobile) {
      provider.network = "Mobile";
      provider.thirdSecReq = true;
    } else if (result == ConnectivityResult.wifi) {
      provider.network = "Wi-Fi";
    } else if (result == ConnectivityResult.ethernet) {
      provider.network = "Ethernet";
      provider.thirdSecReq = true;
    } else if (result == ConnectivityResult.vpn) {
      provider.network = "VPN";
      provider.thirdSecReq = true;
    } else if (result == ConnectivityResult.other) {
      provider.network = "Other";
    } else if (result == ConnectivityResult.none) {
      provider.network = "None";
    }
  }
}

class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/connect';
  late var connectionPage;
  late Map<String, String> queryParameters;
  PassArgumentsScreen(Map<String, String> queryParameters) {
    this.queryParameters = queryParameters;
    connectionPage =
        ConnectionPage(id: queryParameters['id'], pw: queryParameters['pw']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.grayBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text("RustDesk"),
        actions: connectionPage.appBarActions,
      ),
      body: connectionPage,
    );
  }
}
