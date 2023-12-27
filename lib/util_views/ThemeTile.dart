import 'package:flutter/material.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';

class ThemeTile extends StatefulWidget {
  const ThemeTile({super.key});

  @override
  State<ThemeTile> createState() => _ThemeTileState();
}

class _ThemeTileState extends State<ThemeTile> {
  @override
  Widget build(BuildContext context) {
    var isLight = AppState.themeMode.value == ThemeMode.light;
    return ListTile(
      title: Text(
          isLight ? Tprovider.get('dark_mode') : Tprovider.get('light_mode')),
      leading: Icon(isLight ? Icons.dark_mode : Icons.light_mode),
      onTap: () async {
        AppState.toggleThemeMode();
        setState(() {});
      },
    );
  }
}
