import 'package:buspay/screens/map_screen.dart';
import 'package:buspay/screens/scanner.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.blue);
    return MaterialApp(
      title: 'BusPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      routes: {
        '/MapScreen': (context) => const MapScreen(),
        '/Scanner': (context) => const Scanner()
      },
      home: MapScreen(),
    );
  }
}
