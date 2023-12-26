class PasswordCombinationResponse {
  String? pcid;
  List<int>? indices;

  PasswordCombinationResponse({this.pcid, this.indices});


  PasswordCombinationResponse.fromJson(Map<String, dynamic> json) {
    pcid = json['pcid'];
    indices = json['indices'].cast<int>();
  }
  
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pcid'] = this.pcid;
    data['indices'] = this.indices;
    return data;
  }
}
