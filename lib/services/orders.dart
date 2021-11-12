import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future placeOrder(String uid, int adult, int child, int fee, String stRoute,
      String endRoute) async {
    var collection = FirebaseFirestore.instance.collection('orders');
    var result = await collection.doc(getRandomString(12)).set({
      "adult": adult,
      "child": child,
      "date": DateTime.now(),
      "fee": fee,
      // "orderId": getRandomString(10),
      "stRoute": stRoute,
      "endRoute": endRoute,
      "uid": uid,
    });
    // print('oder placed');
    return result;
  }

  // getOrders(String uid) async {
  //   final CollectionReference allOrders =
  //       FirebaseFirestore.instance.collection('orders');
  //   var myOrdersData = await allOrders.where("uid", isEqualTo: uid).get();
  //   // List myOrders = [];
  //   // myOrdersData.docs.forEach((element) {
  //   //   myOrders.add(element.data());
  //   // });

  //   // if (myOrdersData.docs.isEmpty) {
  //   //   print('No data');
  //   // }
  //   return myOrdersData;
  // }
}
