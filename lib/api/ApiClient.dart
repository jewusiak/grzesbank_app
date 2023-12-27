import 'dart:convert';

import 'package:grzesbank_app/api/exceptions/HttpUnexpectedResponseError.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/utils/Constants.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';

class ApiClient {
  ApiClient._constructor();

  static final ApiClient instance = ApiClient._constructor();

  final String _host = Constants.apiHost;
  final int _port = Constants.apiPort;
  final String _httpProtocol = Constants.apiProtocol;
  static const _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  final AppState appState = Provider.of<AppState>(
      NavigationContext.mainNavKey.currentContext!,
      listen: false);

  static _convertQueryParams(Map<String, dynamic>? map) {
    if (map == null) return;
    for (var key in map.keys) {
      map[key] = "${map[key]}";
    }
    return map;
  }

  Future<dynamic> get(String path,
      {Map<String, dynamic>? urlParams,
      dynamic Function(Map<String, dynamic>)? cast,
      Map<String, String>? headers,
      int successCode = 200,
      bool refreshAuthOnSuccess = false}) async {
    var res = await Requests.get(
        Uri(
                scheme: _httpProtocol,
                host: _host,
                port: _port,
                path: path,
                queryParameters: _convertQueryParams(urlParams))
            .toString(),
        headers: {..._baseHeaders, ...?headers},
        withCredentials: true);
    handleHttpResponseCode(res, successCode, refreshAuthOnSuccess);
    return cast?.call(res.json()) ?? res;
  }

  Future<dynamic> delete(String path,
      {Map<String, dynamic>? urlParams,
      dynamic Function(Map<String, dynamic>)? cast,
      Map<String, String>? headers,
      int successCode = 200,
      bool refreshAuthOnSuccess = false}) async {
    var res = await Requests.delete(
        Uri(
                scheme: _httpProtocol,
                host: _host,
                port: _port,
                path: path,
                queryParameters: urlParams)
            .toString(),
        headers: {..._baseHeaders, ...?headers});
    handleHttpResponseCode(res, successCode, refreshAuthOnSuccess);
    return cast?.call(json.decode(res.body)) ?? res;
  }

  Future<dynamic> post(String path,
      {Map<String, dynamic>? urlParams,
      dynamic Function(Map<String, dynamic>)? cast,
      Map<String, dynamic>? body,
      Map<String, String>? headers,
      int successCode = 200,
      bool refreshAuthOnSuccess = false}) async {
    var res = await Requests.post(
        Uri(
                scheme: _httpProtocol,
                host: _host,
                port: _port,
                path: path,
                queryParameters: urlParams)
            .toString(),
        headers: {..._baseHeaders, ...?headers},
        json: body,
        withCredentials: true);
    handleHttpResponseCode(res, successCode, refreshAuthOnSuccess);
    return cast?.call(res.json()) ?? res;
  }

  Future<dynamic> put(String path,
      {Map<String, dynamic>? urlParams,
      dynamic Function(Map<String, dynamic>)? cast,
      Map<String, dynamic>? body,
      Map<String, String>? headers,
      int successCode = 200,
      bool refreshAuthOnSuccess = false}) async {
    var res = await Requests.put(
        Uri(
                scheme: _httpProtocol,
                host: _host,
                port: _port,
                path: path,
                queryParameters: urlParams)
            .toString(),
        body: json.encode(body),
        headers: {..._baseHeaders, ...?headers});
    handleHttpResponseCode(res, successCode, refreshAuthOnSuccess);
    return cast?.call(json.decode(res.body)) ?? res;
  }

  Future<dynamic> patch(String path,
      {Map<String, dynamic>? urlParams,
      dynamic Function(Map<String, dynamic>)? cast,
      Map<String, dynamic>? body,
      Map<String, String>? headers,
      int successCode = 200,
      bool refreshAuthOnSuccess = false}) async {
    var res = await Requests.patch(
        Uri(
                scheme: _httpProtocol,
                host: _host,
                port: _port,
                path: path,
                queryParameters: urlParams)
            .toString(),
        body: body,
        headers: {..._baseHeaders, ...?headers});
    handleHttpResponseCode(res, successCode, refreshAuthOnSuccess);
    return cast?.call(json.decode(res.body)) ?? res;
  }

  void handleHttpResponseCode(
      http.Response res, int successCode, bool refreshAuthOnSuccess) {
    if (res.statusCode == successCode) {
      if (refreshAuthOnSuccess) {
        appState.refreshValidity();
      }
      return;
    }
    if (res.statusCode == 403) {
      if (appState.isAuthenticated) {
        ErrorDialog.show(NavigationContext.mainNavKey.currentContext!,
            Tprovider.get('end_session_err'));
      }
      appState.setStatelogout();
      return;
    }
    throw HttpUnexpectedResponseError(res);
  }

  Future clearCookies() async {
    await Requests.clearStoredCookies(_host);
  }
}
