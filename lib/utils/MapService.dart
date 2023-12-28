import 'package:location/location.dart';

class MapService {
  static Location _location = Location();

  static Future<bool> requestPermission() async {
    final permission = await _location.requestPermission();
    return permission == PermissionStatus.granted;
  }

  static Future<LocationData> getCurrentLocation() async {
    final serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      final result = await _location.requestService;
      if (result == true) {
        print('Service has been enabled');
      } else {
        throw Exception('GPS service not enabled');
      }
    }

    final locationData = await _location.getLocation();
    return locationData;
  }
}
