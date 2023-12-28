import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:grzesbank_app/state/AppState.dart';

class Tprovider {
  static Map<String, Language>? _phrases; //language -> map of translations

  static Future<bool> init() async {
    final js = jsonDecode(await DefaultAssetBundle.of(
            NavigationContext.mainNavKey.currentContext!)
        .loadString("assets/translations.json"));
    _phrases = {};
    for (var trans in js) {
      var lang = Language(trans['lang']);
      var translationsMap = Map.from(trans['translations'])
          .map((key, value) => MapEntry(key.toString(), value.toString()));
      lang.addTranslations(translationsMap);
      _phrases![trans['lang']] = lang;
    }
    return true;
  }

  static String get(String key) {
    var s = _phrases?[AppState.instance.lang]?.translations[key];
    if (s == null) print("not found: $key for lang ${AppState.instance.lang}");
    return s ?? "{$key}";
  }
}

class Language {
  final String _language;
  final Map<String, String> _translations = {}; //key -> translation

  Language(this._language);

  void addTranslation(String key, String trans) {
    _translations[key] = trans;
  }

  void addTranslations(Map<String, String> translations) {
    _translations.addAll(translations);
  }

  Map<String, String> get translations => _translations;

  String get language => _language;
}
