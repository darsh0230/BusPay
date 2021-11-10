import 'package:flutter/material.dart';
import 'package:buspay/services/bus_data.dart';

class Buss extends StatefulWidget {
  const Buss({Key? key}) : super(key: key);

  @override
  _BussState createState() => _BussState();
}

class _BussState extends State<Buss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: TextButton(
        onPressed: () {
          busData.fetchData();
          print(busData.route!["0"]);
        },
        child: Text('click me'),
      ),
    );
  }
}

BusData busData = BusData(busId: "KA04MX0001");
