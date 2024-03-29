import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:buspay/providers/route_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool enableMarkers = false;
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(13.0368676, 77.5631121), zoom: 14.5);
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  // BitmapDescriptor curLocIcon = BitmapDescriptor.defaultMarker;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _onMapCreated(controller) async {
    // print(context.watch<RouteProvider>().stopNames);
    // var _auth = FirebaseAuth.instance;
    // print(_auth.currentUser!.uid);

    mapsController = controller;
    //TODO: get this at the start of the app and display a page if location is not enabled like in bounce
    _serviceEnabled = await locationTracker.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await locationTracker.requestService();
      if (!_serviceEnabled!) {
        print('Service not enabled');
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
    newLoactionData = _locationData;
    updateMarkerAndCircle(_locationData);
    gotoLocation(_locationData.latitude, _locationData.longitude);

    locationTracker.onLocationChanged.listen((newLocData) {
      newLoactionData = newLocData;
      updateMarkerAndCircle(newLocData);
      // print(newLocData);
    });
  }

  void updateBusRouteMarkers(busRoute) {
    setState(() {
      if (busRoute.stopNames.length > 0 && enableMarkers) {
        for (int i = 0; i < busRoute.stopNames.length; i++) {
          // print(busRoute.stopNames[i]);
          mapsMarkers.add(Marker(
              markerId: MarkerId(busRoute.stopNames[i]),
              position: LatLng(
                busRoute.stopPoints[i].latitude,
                busRoute.stopPoints[i].longitude,
              ),
              infoWindow: InfoWindow(title: busRoute.stopNames[i]),
              draggable: false,
              icon: BitmapDescriptor.defaultMarker));
        }
      }
    });
  }

  void updateMarkerAndCircle(newLocData) {
    LatLng latlng = LatLng(newLocData.latitude, newLocData.longitude);
    setState(() {
      mapsMarkers.add(Marker(
          markerId: MarkerId('my_loc'),
          position: latlng,
          draggable: false,
          // icon: curLocIcon,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet)));
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
  //           'assets/imgs/location-arrow-flat.png')
  //       .then((d) {
  //     curLocIcon = d;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var busRoute = context.watch<RouteProvider>();
    updateBusRouteMarkers(busRoute);
    // setState(() {});
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Welcome to BusPay'),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.screen_search_desktop_outlined),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('My Bookings'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/myOrders');
                // Orders _orders = Orders();
                // var _auth = FirebaseAuth.instance;
                // _orders.getOrders(_auth.currentUser!.uid);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('My Wallet: ₹500'),
                  ),
                ],
              ),
              onTap: () {},
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('logout'),
                  ),
                ],
              ),
              onTap: () async {
                var _auth = FirebaseAuth.instance;
                await _auth.signOut();
                Navigator.of(context).pushReplacementNamed('/signIn');
              },
            ),
          ],
        ),
      ),
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
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  gotoLocation(
                      newLoactionData!.latitude, newLoactionData!.longitude);
                },
                child: Icon(Icons.my_location),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    enableMarkers = !enableMarkers;
                    mapsMarkers = {};
                    updateMarkerAndCircle(newLoactionData);
                  });
                },
                child: Icon(
                    enableMarkers ? Icons.location_off : Icons.location_on),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 45.0),
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState!.openDrawer(),
                        icon: Icon(Icons.menu)),
                    Flexible(
                        child: Form(
                            child: TextFormField(
                                decoration: textInputDecoration))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

GoogleMapController? mapsController;
Location locationTracker = new Location();
LocationData? newLoactionData;
Set<Marker> mapsMarkers = {};

Future<void> gotoLocation(double? lat, double? long) async {
  final GoogleMapController controller = mapsController!;
  controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    target: LatLng(lat!, long!),
    zoom: 15,
    // tilt: 50.0,
    bearing: 45.0,
  )));
}

const textInputDecoration = InputDecoration(
  hintText: 'Enter Location',
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  // border: OutlineInputBorder(
  //   borderRadius: const BorderRadius.all(
  //     Radius.circular(40.0),
  //   ),
  // ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
);
