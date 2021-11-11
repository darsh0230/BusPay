import 'package:flutter/material.dart';

class RouteProvider with ChangeNotifier {
  List stopNames = [];
  List stopPoints = [];

  void updateRoute(stopNames, stopPoints) {
    print('changed');
    this.stopNames = stopNames;
    this.stopPoints = stopPoints;
    notifyListeners();
  }
}
