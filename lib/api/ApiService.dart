import 'dart:async';

import 'package:grzesbank_app/api/ApiClient.dart';
import 'package:grzesbank_app/api/exceptions/HttpUnexpectedResponseError.dart';
import 'package:grzesbank_app/api/responses/AccountSummaryResponse.dart';
import 'package:grzesbank_app/api/responses/CcDataResponse.dart';
import 'package:grzesbank_app/api/responses/PasswordCombinationResponse.dart';
import 'package:grzesbank_app/api/responses/SensitiveDataResponse.dart';
import 'package:grzesbank_app/api/responses/TransactionHistoryPageResponse.dart';
import 'package:grzesbank_app/api/responses/UserBasicData.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:provider/provider.dart';

class ApiService {
  ApiService._constructor();

  static final ApiService instance = ApiService._constructor();

  final ApiClient _client = ApiClient.instance;

  final AppState appState = Provider.of<AppState>(
      NavigationContext.mainNavKey.currentContext!,
      listen: false);

  Future<PasswordCombinationResponse> requestPasswordCombinations(
      String email) async {
    return await _client.get('/auth/login',
        urlParams: {'email': email},
        cast: PasswordCombinationResponse.fromJson);
  }

  Future<UserBasicData?> authenticate(
      String pcid, String email, String password) async {
    var body = {'pcid': pcid, 'email': email, 'password': password};
    try {
      return await _client.post("/auth/login",
          body: body, cast: UserBasicData.fromJson);
    } on HttpUnexpectedResponseError {
      return null;
    }
  }

  Future<bool> ping() async {
    try {
      await _client.get('/profile/ping',
          successCode: 202, refreshAuthOnSuccess: true);
    } on HttpUnexpectedResponseError {
      return false;
    }
    return true;
  }

  Future<UserBasicData?> getUserBasicData() async {
    return await _client.get('/profile/basicdata',
        cast: UserBasicData.fromJson);
  }

  Future<AccountSummaryResponse> getAccountSummary() async {
    return await _client.get('/profile/summary',
        cast: AccountSummaryResponse.fromJson, refreshAuthOnSuccess: true);
  }

  Future sendLogoutRequest() async {
    await _client.post("/auth/logout", successCode: 204);
    await _client.clearCookies();
  }

  Future<TransactionHistoryPageResponse> getTransactionHistory(
      {int page = 0, int size = 10}) async {
    return await _client.get('/transactions',
        refreshAuthOnSuccess: true,
        cast: TransactionHistoryPageResponse.fromJson,
        urlParams: {'page': page, 'size': size});
  }

  Future<String?> sendTransfer(String recipientname, String recipientaddress,
      String recipientAccn, String amount, String title) async {
    var data = {
      "recipientName": recipientname,
      "recipientAddress": recipientaddress,
      "recipientAccountNumber": recipientAccn.replaceAll(RegExp(r"[^0-9]"), ''),
      "amount": double.tryParse(amount),
      "title": title
    };
    try {
      await _client.post('/transactions/create',
          body: data, refreshAuthOnSuccess: true);
    } on HttpUnexpectedResponseError catch (e) {
      if (e.response.statusCode == 418)
        return Tprovider.get('insufficient_funds');
      if (e.response.statusCode == 400) return Tprovider.get('invalid_form');
      return "${Tprovider.get('unexpected_err')} ${e.response.statusCode}";
    }
    return null;
  }

  Future<bool> registerNewUser(
      String firstName,
      String lastName,
      String email,
      String password,
      String street,
      String zip,
      String city,
      String pesel,
      String documentNumber,
      String? initialBalance) async {
    var data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'address': {'street': street, 'zipCode': zip, 'city': city},
      'pesel': pesel,
      'documentNumber': documentNumber,
      'initialBalance': double.tryParse(initialBalance ?? "0") ?? 0
    };
    try {
      await ApiClient.instance.post('/auth/register', body: data);
      return true;
    } on HttpUnexpectedResponseError {
      return false;
    }
  }

  Future<CcDataResponse> getCcData() async {
    return await _client.get('/profile/sensitive/cc',
        cast: CcDataResponse.fromJson, refreshAuthOnSuccess: true);
  }

  Future<SensitiveDataResponse> getSensitiveData() async {
    await Future.delayed(Duration(milliseconds: 500));
    return await _client.get('/profile/sensitive/data',
        cast: SensitiveDataResponse.fromJson, refreshAuthOnSuccess: true);
  }

  Future<bool> changePassword(String pass) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      await _client.post('/profile/changepassword',
          body: {'password': pass}, refreshAuthOnSuccess: true);
      return true;
    } on HttpUnexpectedResponseError {
      return false;
    }
  }

  Future<bool> changePasswordWithToken(String pass, String token) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      await _client.put('/auth/resetpassword',
          body: {'password': pass, 'token': token});
      return true;
    } on HttpUnexpectedResponseError catch (e){
      return false;
    }
  }
  Future<bool> requestPasswordReset(String email) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      await _client.post('/auth/resetpassword', urlParams: {'email':email});
      return true;
    } on HttpUnexpectedResponseError catch (e){
      return false;
    }
  }
}
