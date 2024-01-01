import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/utils/Constants.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/authd_views/AuthdHomeView.dart';
import 'package:grzesbank_app/widgets/nav/DrawerProvider.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';
import 'package:grzesbank_app/widgets/unauthd_views/UnauthdPassChangeView.dart';
import 'package:grzesbank_app/widgets/unauthd_views/UnauthenticatedHomeView.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
      ],
      child: ValueListenableBuilder(
        valueListenable: AppState.themeMode,
        builder: (context, value, child) => MaterialApp(
          navigatorKey: NavigationContext.mainNavKey,
          title: 'Grzesbank',
          theme: ThemeData.light(
              useMaterial3:
                  true) /*ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          )*/
          ,
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: value,
          routes: {
            "/": (context) => HomePage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name?.startsWith("/resetpass") ?? false) {
              //checks if reset pass route is called
              var params = Uri.parse(settings.name!).queryParameters;
              if (params['token'] != null) {
                return MaterialPageRoute(
                  builder: (context) => UnauthdPassChangeView(params['token']!),
                );
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future _prepareAppFuture = Future(() async {
    try {
      //init translations
      print("Labels init begin...");
      await Tprovider.init();
      print("Labels initiated");

      //init constants
      print("const init begin...");
      Constants.init();
      print("const init end");

      //recall login state begin
      try {
        var user = await ApiService.instance.getUserBasicData();
        Provider.of<AppState>(NavigationContext.mainNavKey.currentContext!,
                listen: false)
            .setStateLogin(user!);
        print("recalled login state");
      } catch (e) {
        print("no recall of login state");
      }
    } catch (e) {
      ErrorDialog.show(NavigationContext.mainNavKey.currentContext!,
          Tprovider.get('startup_err'),
          onOk: () async {});
      rethrow;
    }
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return FutureBuilder(
      future: _prepareAppFuture,
      builder: (context, snapshot) {
        print("conn state: ${snapshot.connectionState.name}");
        return snapshot.connectionState == ConnectionState.done
            ? AppScaffold(
                title: Text("Grzesbank24"),
                drawer: DrawerProvider(),
                body: appState.isAuthenticated
                    ? AuthdHomeView()
                    : UnauthenticatedHomeView())
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
