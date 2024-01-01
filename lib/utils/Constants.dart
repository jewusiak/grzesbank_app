class Constants {
  static void init() {
    if (_apiProtocol == "-1") throw Exception("Env var api_proto not set");
    if (_apiPort == "-1") throw Exception("Env var api_port not set");
    if (_apiHost == "-1") throw Exception("Env var api_host not set");
  }

  static const String _apiHost =
      String.fromEnvironment("API_HOST", defaultValue: "-1"); // = "localhost";
  static const String _apiPath =
      String.fromEnvironment("API_PATH", defaultValue: ""); // = "/api";
  static const String _apiPort =
      String.fromEnvironment("API_PORT", defaultValue: "-1"); // = 443;
  static const String _apiProtocol =
      String.fromEnvironment("API_PROTOCOL", defaultValue: "-1"); // = "https";

  static String get apiHost => _apiHost;

  static String get apiPath => _apiPath;

  static String get apiProtocol => _apiProtocol;

  static int get apiPort => int.parse(_apiPort);
}
