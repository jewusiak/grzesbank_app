import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/utils/MapService.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';
import 'package:location/location.dart';

class BankLocationView extends StatefulWidget {
  const BankLocationView({super.key});

  @override
  State<BankLocationView> createState() => _BankLocationViewState();
}

class _BankLocationViewState extends State<BankLocationView> {
  bool _showMap = false;
  LocationData? _locData;
  BitmapDescriptor? _iconBitmap;

  @override
  Widget build(BuildContext context) {
    if (!_showMap) {
      MapService.requestPermission().then((value) async {
        if (value == false) {
          ErrorDialog.show(NavigationContext.mainNavKey.currentContext!,
              Tprovider.get('permission_denied_err'), onOk: () async {
            Navigator.pop(NavigationContext.mainNavKey.currentContext!);
            Navigator.pop(NavigationContext.mainNavKey.currentContext!);
          });
          return;
        }
        _locData = await MapService.getCurrentLocation();
        _iconBitmap = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), "assets/loc_pin.png");
        setState(() => _showMap = true);
      });
    }
    return AppScaffold(
      title: Text(Tprovider.get('bank_locations_drawer')),
      body: _showMap
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(_locData!.latitude!, _locData!.longitude!),
                  zoom: 13),
              markers: [
                Marker(
                    markerId: MarkerId("user"),
                    position: LatLng(_locData!.latitude!, _locData!.longitude!),
                    icon: _iconBitmap ??
                        BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure),
                    infoWindow:
                        InfoWindow(title: Tprovider.get('your_location'))),
                Marker(
                    markerId: MarkerId("bank"),
                    position: LatLng(52.231826, 21.002149),
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: InfoWindow(
                      title:
                          "${Tprovider.get('branch_no')} 1 - Sienna 39, Warszawa",
                    )),
              ].toSet(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
