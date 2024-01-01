import 'package:grzesbank_app/api/responses/dtos/TransactionDto.dart';
import 'package:grzesbank_app/utils/Formatters.dart';

class AccountSummaryResponse {
  String? name;
  String? accountNumber;
  String? email;
  double? balance;
  List<TransactionDto>? lastTransactions;

  AccountSummaryResponse(
      {this.name,
      this.accountNumber,
      this.email,
      this.balance,
      this.lastTransactions});

  AccountSummaryResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    accountNumber = json['accountNumber'];
    email = json['email'];
    balance = json['balance'].toDouble();
    if (json['lastTransactions'] != null) {
      lastTransactions = <TransactionDto>[];
      json['lastTransactions'].forEach((v) {
        lastTransactions!.add(new TransactionDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['accountNumber'] = this.accountNumber;
    data['email'] = this.email;
    data['balance'] = this.balance;
    if (this.lastTransactions != null) {
      data['lastTransactions'] =
          this.lastTransactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String get formattedAccountNumber =>
      Formatters.formatAccountNumber(accountNumber, assertLength: false);
}
