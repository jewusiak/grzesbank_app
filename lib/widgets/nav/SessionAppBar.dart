import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  final Widget title;
  final Widget? drawer;
  final Widget? body;

  const AppScaffold({super.key, this.drawer, required this.title, this.body});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
        body: body,
        drawer: drawer,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: title,
          actions: getTimerWidgets(appState),
        ));
  }

  List<Widget> getTimerWidgets(AppState appState) {
    return appState.isAuthenticated == true && appState.sessionValidity != null
        ? [
            IconButton(
                onPressed: ApiService.instance.ping, icon: Icon(Icons.refresh)),
            SizedBox(
              width: 5,
            ),
            TimeWidget(),
            SizedBox(
              width: 30,
            )
          ]
        : [];
  }
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: appState.sessionValidityValueNotifier,
      builder: (context, value, child) => Text(
        "${Tprovider.get('session_time')}: ${(value! / 60).floor()}:${(value % 60).toString().padLeft(2, '0')}",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
