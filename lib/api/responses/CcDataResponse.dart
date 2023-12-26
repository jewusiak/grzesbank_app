class CcDataResponse {
  String? cardNumber;
  String? validity;
  String? cvv;

  CcDataResponse({this.cardNumber, this.validity, this.cvv});

  CcDataResponse.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'];
    validity = json['validity'];
    cvv = json['cvv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNumber'] = this.cardNumber;
    data['validity'] = this.validity;
    data['cvv'] = this.cvv;
    return data;
  }
}
