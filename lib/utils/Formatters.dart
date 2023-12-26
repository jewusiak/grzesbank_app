import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatters {
  static NumberFormat _numberFormat = NumberFormat("############.00", "pl_PL");
  static DateFormat _dateFormat = DateFormat("dd.MM.yyyy (HH:mm)");

  static String formatAmount(double amount) {
    return _numberFormat.format(amount);
  }
  
  static String formatDate(String zuluDate) {
    return _dateFormat.format(DateTime.parse(zuluDate).toLocal());
  }

  static String formatAccountNumber(String? accountNumber, {bool assertLength = true}) {
    if (accountNumber == null || accountNumber.length != 26 && assertLength) {
      return "n/a";
    }
    accountNumber = accountNumber.replaceAll(" ", "");
    
    var arr = "";
    int i = 0;
    
    for (var c in accountNumber.characters) {
      arr +=  ((i+++2) % 4 == 0 ? " " : "")+c;
    }
    return arr;
  }
  
  static String formatCcNumber(String? ccn) {
    if (ccn == null ) {
      return "????  ????  ????  ????";
    }    
    var arr = "";
    int i = 0;
    
    for (var c in ccn.characters) {
      arr +=  ((i++) % 4 == 0 ? "  " : "")+c;
    }
    return arr.substring(1);
  }
}

class AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var s = Formatters.formatAccountNumber(newValue.text, assertLength: false);
    var sel = TextSelection.collapsed(offset: newValue.selection.end+s.length-newValue.text.length);
    return TextEditingValue(text: s, selection: sel);
  }

} 