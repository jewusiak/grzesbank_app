class SensitiveDataResponse {
  String? pesel;
  String? documentNumber;

  SensitiveDataResponse({this.pesel, this.documentNumber});

  SensitiveDataResponse.fromJson(Map<String, dynamic> json) {
    pesel = json['pesel'];
    documentNumber = json['documentNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pesel'] = this.pesel;
    data['documentNumber'] = this.documentNumber;
    return data;
  }
}
