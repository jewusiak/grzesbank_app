import 'package:http/http.dart' as http;

class HttpUnexpectedResponseError {
  http.Response _response;

  HttpUnexpectedResponseError(this._response);

  http.Response get response => _response;
}
