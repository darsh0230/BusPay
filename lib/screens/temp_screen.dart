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
          // busData.busId = "KA04MX0002";
          // // setState(() {});
          // // print(busData.busId);
          // busData.fetchData();
          // print(busData.route);
        },
        child: Text('click me'),
      ),
    );
  }
}

class TRoutess extends StatefulWidget {
  const TRoutess({Key? key}) : super(key: key);

  @override
  _TRoutessState createState() => _TRoutessState();
}

class ScreenArguments {
  var routes;
  ScreenArguments(this.routes);
}

class _TRoutessState extends State<TRoutess> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    BusRoute _bus = BusRoute(args.routes);
    return Scaffold(
      appBar: AppBar(
        title: Text('tmp'),
      ),
      body: Text(args.routes.toString()),
    );
  }
}
