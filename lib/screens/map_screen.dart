import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(13.0368676, 77.5631121), zoom: 14.5);
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  Future<void> _onMapCreated(controller) async {
    mapsController = controller;
    //TODO: get this at the start of the app and display a page if location is not enabled like in bounce
    _serviceEnabled = await locationTracker.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await locationTracker.requestService();
      if (!_serviceEnabled!) {
        print('Service not enebled');
        return;
      }
    }
    _permissionGranted = await locationTracker.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationTracker.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var _locationData = await locationTracker.getLocation();
    updateMarkerAndCircle(_locationData);

    locationTracker.onLocationChanged.listen((newLocData) {
      newLoactionData = newLocData;
      updateMarkerAndCircle(newLocData);
      // print(newLocData);
    });
  }

  void updateMarkerAndCircle(newLocData) {
    LatLng latlng = LatLng(newLocData.latitude, newLocData.longitude);
    setState(() {
      mapsMarkers.add(Marker(
        markerId: MarkerId('my_loc'),
        position: latlng,
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onMapCreated,
            zoomControlsEnabled: false,
            markers: mapsMarkers,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              side: BorderSide(color: Colors.blue))),
                      // foregroundColor:
                      //     MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/Scanner');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60.0, vertical: 8.0),
                      child: Text(
                        'Scanner',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}

GoogleMapController? mapsController;
Location locationTracker = new Location();
LocationData? newLoactionData;
Set<Marker> mapsMarkers = {};
