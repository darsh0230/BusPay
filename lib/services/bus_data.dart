import 'package:cloud_firestore/cloud_firestore.dart';

class BusRoute {
  String? busId;
  Map? route = {};
  List stopNames = [];
  List stopPoints = [];
  List<bool> isfocused = [];
  int startRoute = 0;
  int endRoute = -1;

  BusRoute(route) {
    this.route = route;
    stopNames = [];
    stopPoints = [];
    for (int i = 0; i < route.length; i++) {
      stopNames.add(route[i.toString()].keys.elementAt(0));
      stopPoints.add(route[i.toString()].values.elementAt(0));
      isfocused.add(i == 0 ? true : false);
    }
    // print(stopNames);
  }
}
