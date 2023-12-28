import 'package:flutter/material.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:provider/provider.dart';

class LangTile extends StatelessWidget {
  const LangTile({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return ListTile(
      title: Text(appState.lang == 'pl_PL' ? "English" : "Polski"),
      leading: Icon(Icons.language),
      onTap: () {
        appState.toggleLang();
      },
    );
  }
}
