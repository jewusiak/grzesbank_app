import 'package:grzesbank_app/utils/Formatters.dart';

class UserBasicData {
  String? firstName;
  String? surname;
  String? email;
  String? accountNumber;

  UserBasicData({this.firstName, this.surname, this.email, this.accountNumber});

  UserBasicData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    surname = json['surname'];
    email = json['email'];
    accountNumber = json['accountNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['surname'] = this.surname;
    data['email'] = this.email;
    data['accountNumber'] = this.accountNumber;
    return data;
  }

  String get formattedAccountNumber =>
      Formatters.formatAccountNumber(accountNumber);
}
