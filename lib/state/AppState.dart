import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/responses/UserBasicData.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:provider/provider.dart';

class AppState extends ChangeNotifier {
  bool _isAuthenticated = false;
  ValueNotifier<int?> _sessionValidity = ValueNotifier(null);
  String _lang = "en_US";
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  
  static void toggleThemeMode() {
    themeMode.value = themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    themeMode.notifyListeners();
  }
  
  set isAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  String get lang => _lang;
  
  void toggleLang() {
    lang = lang == 'pl_PL' ? 'en_US' : 'pl_PL';
  }

  set lang(String value) {
    _lang = value;
    notifyListeners();
  }

  int? get sessionValidity => _sessionValidity.value;
  ValueNotifier<int?> get sessionValidityValueNotifier => _sessionValidity;

  bool get isAuthenticated => _isAuthenticated;

  void refreshValidity() {
    print("refreshValidity()");
    _sessionValidity.value = 5*60; //in seconds
    _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_sessionValidity.value == null || !_isAuthenticated) {
        _timer.cancel();
        return;
      }
      _sessionValidity.value = _sessionValidity.value! - 1;
      if (_sessionValidity.value == 0) {
        _timer.cancel();
        setStatelogout();
        Navigator.popUntil(NavigationContext.mainNavKey.currentContext!, (route) => route.isFirst);
        ErrorDialog.show(NavigationContext.mainNavKey.currentContext!, "Sesja zakończyła się. Zaloguj się ponownie,", onOk: () async => Navigator.pop(NavigationContext.mainNavKey.currentContext!));
      }
      _sessionValidity.notifyListeners();
    });
    //notifyListeners();
  }

  Timer _timer = Timer(Duration.zero, () {});

  void setStateLogin(UserBasicData userBasicData) {
    isAuthenticated = true;
    _userBasicData = userBasicData;
    refreshValidity();
  }

  void setStatelogout() {
    isAuthenticated = false;
    _userBasicData = null;
    _sessionValidity.value = null;
    notifyListeners();
  }

  UserBasicData? _userBasicData;

  UserBasicData? get userBasicData => _userBasicData;
  
  static AppState get instance => Provider.of(NavigationContext.mainNavKey.currentContext!, listen: false);

}

class NavigationContext {
  static final _mainNavKey = GlobalKey<NavigatorState>();
  static final _authNavKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get mainNavKey => _mainNavKey;
  static GlobalKey<NavigatorState> get authNavKey => _authNavKey;
}
