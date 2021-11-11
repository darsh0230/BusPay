import 'package:buspay/providers/route_provider.dart';
import 'package:buspay/screens/map_screen.dart';
import 'package:buspay/screens/routes.dart';
import 'package:buspay/screens/scanner.dart';
import 'package:buspay/screens/ticket.dart';
import 'package:buspay/services/bus_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:buspay/screens/temp_screen.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => RouteProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.blue);
    Firebase.initializeApp();
    return MaterialApp(
      title: 'BusPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      routes: {
        '/MapScreen': (context) => const MapScreen(),
        '/Scanner': (context) => const Scanner(),
        '/RouteTimeline': (context) => const RouteTimeline(),
        '/ticket': (context) => const TicketScreen(),
        '/temp': (context) => const TRoutess(),
      },
      home: MapScreen(),
      // home: TicketScreen(),
    );
  }
}
