import 'package:buspay/services/orders.dart';
import 'package:buspay/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  getOrders() async {
    List myOrders = [];
    // Orders _orders = Orders();
    var _auth = FirebaseAuth.instance;
    final CollectionReference allOrders =
        FirebaseFirestore.instance.collection('orders');
    await allOrders
        .where("uid", isEqualTo: _auth.currentUser!.uid)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        myOrders.add(element.data());
      });
    });

    // print(myOrders[0]);
    return myOrders;
  }

  Widget _myOrderCards(context, myOrders) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd H:m:s');
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          color: Colors.white,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: Color(0x802196F3),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 120.0,
            // margin: ,
            child: Text(myOrders.toString()),
            // child: Text(formatter.format(myOrders['date'].toDate())),
          ),
        ),
      ),
    );
  }

  Widget buildOrders(myOrders) => ListView.builder(
        itemCount: myOrders.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return _myOrderCards(context, myOrders[index]);
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        body: FutureBuilder(
          future: getOrders(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loading();
              default:
                if (snapshot.hasError) {
                  return Text('Error');
                } else {
                  // print(_myOrder.length);
                  return buildOrders(snapshot.data);
                }
            }
          },
        ));
  }
}
