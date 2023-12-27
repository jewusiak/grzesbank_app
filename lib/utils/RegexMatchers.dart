import 'package:grzesbank_app/utils/Tprovider.dart';

class RegexMatchers {
  static final _plAlphaText =
      RegExp(r"^[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ\-]+$", unicode: true);
  static final _plTextbox =
      RegExp(r"^[0-9A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ\-_/ ,]+$", unicode: true);
  static final _email =
      RegExp(r"^[0-9A-Za-z\-+~]+@([A-Za-z0-9\-]+\.)+[A-Za-z]{2,}$", unicode: true);
  static final _idNumber = RegExp(r"^[A-Za-z]{3} ?[0-9]{6}$", unicode: true);
  static final _number = RegExp(r"[0-9]", unicode: true);
  static final _plZipCode = RegExp(r"^[0-9]{2}-?[0-9]{3}$", unicode: true);
  static final _ccyAmount = RegExp(r"^[0-9]+(\.[0-9]{1,2})?$", unicode: true);
  static final _accNumber = RegExp(r"^([0-9] ?){26}$", unicode: true);
  static final _password = RegExp(
      r"^[A-Za-z0-9żźćńółęąśŻŹĆĄŚĘŁÓŃ\-_ !@#$%^&*()+=\[\]{\}:<>,./?]+$",
      unicode: true);
  static final _passwordAlphaBig = RegExp(r"[A-ZŻŹĆĄŚĘŁÓŃ]+", unicode: true);
  static final _passwordAlphaSmall = RegExp(r"[a-zżźćńółęąś]+", unicode: true);
  static final _passwordNumeric = RegExp(r"[0-9]+", unicode: true);
  static final _passwordSpecial =
      RegExp(r"[\-_!@#$%^&*()+=\[\]{\}:<>,./?]+", unicode: true);

  static String? matchPlAlpha(String? word,
      {bool trim = false,
      bool matchBlank = false,
      bool matchNull = false,
      String? onFailure,
      String? onEmpty}) {
    onFailure ??= Tprovider.get('invalid_textbox');
    onEmpty ??= Tprovider.get('field_cannotempty');
    return _matchRegexWithParams(
        _plAlphaText, word, trim, matchBlank, matchNull, onFailure, onEmpty);
  }

  static String? matchCcyAmount(String? word,
      {bool trim = false,
      bool matchBlank = false,
      bool matchNull = false,
      String? onFailure,
      String? onEmpty}) {
    onFailure ??= Tprovider.get('invalid_textbox');
    onEmpty ??= Tprovider.get('field_cannotempty');
    return _matchRegexWithParams(
        _ccyAmount, word, trim, matchBlank, matchNull, onFailure, onEmpty);
  }

  static String? matchPlTextbox(String? word,
      {bool trim = false,
      bool matchBlank = false,
      bool matchNull = false,
      String? onFailure,
      String? onEmpty}) {
    onFailure ??= Tprovider.get('invalid_textbox');
    onEmpty ??= Tprovider.get('field_cannotempty');
    return _matchRegexWithParams(
        _plTextbox, word, trim, matchBlank, matchNull, onFailure, onEmpty);
  }
  
  static String? matchAccNumber(String? word,
      {bool trim = false,
      bool matchBlank = false,
      bool matchNull = false,
      String? onFailure,
      String? onEmpty}) {
    onFailure ??= Tprovider.get('invalid_textbox');
    onEmpty ??= Tprovider.get('field_cannotempty');
    return _matchRegexWithParams(
        _accNumber, word, trim, matchBlank, matchNull, onFailure, onEmpty);
  }

  static String? matchPlZipCode(String? word,
      {bool trim = false,
      bool matchBlank = false,
      bool matchNull = false,
      String? onFailure,
      String? onEmpty}) {
    onFailure ??= Tprovider.get('invalid_textbox');
    onEmpty ??= Tprovider.get('field_cannotempty');
    return _matchRegexWithParams(
        _plZipCode, word, trim, matchBlank, matchNull, onFailure, onEmpty);
  }

  static String? matchEmail(String? word,
      {bool trim = false,
      bool matchBlank = false,
      bool matchNull = false,
      String? onFailure,
      String? onEmpty}) {
    onFailure ??= Tprovider.get('invalid_textbox');
    onEmpty ??= Tprovider.get('field_cannotempty');
    return _matchRegexWithParams(
        _email, word, trim, matchBlank, matchNull, onFailure, onEmpty);
  }

  static String? matchIdNumber(String? word,
      {bool trim = false,
      bool matchBlank = false,
      bool matchNull = false,
      String? onFailure,
      String? onEmpty}) {
    onFailure ??= Tprovider.get('invalid_textbox');
    onEmpty ??= Tprovider.get('field_cannotempty');
    return _matchRegexWithParams(
        _idNumber, word, trim, matchBlank, matchNull, onFailure, onEmpty);
  }

  static String? matchPassword(String? word, String onFailure,
      String onUndesiredLength, int desiredLength, String onEmpty) {
    if (word == null || word.isEmpty) return onEmpty;
    if (word.length < desiredLength) return onUndesiredLength;
    if (!_password.hasMatch(word)) return onFailure;
    if (!_passwordAlphaBig.hasMatch(word)) return Tprovider.get('perr_big');
    if (!_passwordAlphaSmall.hasMatch(word)) return Tprovider.get('perr_small');
    if (!_passwordNumeric.hasMatch(word)) return Tprovider.get('perr_num');
    if (!_passwordSpecial.hasMatch(word)) return Tprovider.get('perr_spec');
    return null;
  }

  static String? matchNumbers(String? word,
      {bool trim = false,
      bool matchBlank = false,
      bool matchNull = false,
      required String onFailure,
      String? onEmpty,
      String? onUndesiredLength,
      int? desiredLength}) {
    if (word == null) return matchNull ? null : onFailure;
    if (trim) word = word.trim();
    if (word.isEmpty) return matchBlank ? null : onEmpty;
    if (_number.allMatches(word).length != word.length) return onFailure;
    if (desiredLength != null && word.length != desiredLength)
      return onUndesiredLength;
    return null;
  }

  static _matchRegexWithParams(RegExp regExp, String? word, bool trim,
      bool matchBlank, bool matchNull, String onFailure, String? onEmpty) {
    if (word == null) return matchNull ? null : onFailure;
    if (trim) word = word.trim();
    if (word.isEmpty) return matchBlank ? null : onEmpty;
    return regExp.hasMatch(word) ? null : onFailure;
  }
}
