import 'package:grzesbank_app/utils/Formatters.dart';

class TransactionDto {
  String? date;
  String? contraSideName;
  String? title;
  double? amount;

  TransactionDto({this.date, this.contraSideName, this.title, this.amount});

  TransactionDto.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    contraSideName = json['contraSideName'];
    title = json['title'];
    amount = json['amount'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['contraSideName'] = this.contraSideName;
    data['title'] = this.title;
    data['amount'] = this.amount;
    return data;
  }

  String get formattedAmount =>
      amount == null ? "n/a" : Formatters.formatAmount(amount!);

  String get formattedDate =>
      date == null ? "n/a" : Formatters.formatDate(date!);
}
