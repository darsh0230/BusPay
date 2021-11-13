import 'package:buspay/providers/route_provider.dart';
import 'package:buspay/screens/auth/auth.dart';
import 'package:buspay/screens/auth/register.dart';
import 'package:buspay/screens/auth/sign_in.dart';
import 'package:buspay/screens/map_screen.dart';
import 'package:buspay/screens/my_orders.dart';
import 'package:buspay/screens/routes.dart';
import 'package:buspay/screens/scanner.dart';
import 'package:buspay/screens/ticket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:buspay/screens/temp_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => RouteProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        '/signIn': (context) => const SignIn(),
        '/register': (context) => const Register(),
        '/myOrders': (context) => const MyOrders(),
        '/temp': (context) => const TRoutess(),
      },
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    var auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) {
      if (user != null) {
        setState(() => loggedIn = true);
      } else {
        setState(() => loggedIn = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loggedIn) {
      return Auth();
    } else {
      return MapScreen();
    }
  }
}
