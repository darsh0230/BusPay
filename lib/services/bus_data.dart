import 'package:cloud_firestore/cloud_firestore.dart';

class BusData {
  String? busId;
  // List<String>? stopName;
  // List<GeoPoint>? stopPoints;
  Map? route;

  BusData({this.busId});

  void fetchData() async {
    try {
      var collection = FirebaseFirestore.instance.collection('bus');
      var docSnapshot = await collection.doc(this.busId).get();

      if (docSnapshot.exists) {
        Map data = (docSnapshot.data() as Map);
        this.route = (data['route'] as Map);
        // print(route);
        // print(route.values.elementAt(1).values.elementAt(0).latitude);

        // for (int i = 0; i < this.route!.length; i++) {
        // this.stopName!.add(route.keys.elementAt(i));
        // this.stopPoints!.add(route.values.elementAt(i));
        // print(route.keys.elementAt(i));
        // print(route.values.elementAt(i));
        // }
        // print(this.stopName);
        // print(this.stopPoints);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
