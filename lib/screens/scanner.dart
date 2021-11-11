import 'package:buspay/screens/routes.dart';
import 'package:buspay/screens/temp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:buspay/services/bus_data.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? qrResult;
  QRViewController? qrController;
  String QrCode = "";
  bool flashOn = false;

  void _onQRViewCreated(QRViewController controller) {
    this.qrController = controller;
    var collection = FirebaseFirestore.instance.collection('bus');
    bool waiting = false;
    controller.scannedDataStream.listen((scanData) async {
      // print(scanData.code.substring(4));

      setState(() {
        QrCode = "";
        // qrController!.pauseCamera();
      });

      if (scanData.code.contains(new RegExp(r'bus-', caseSensitive: false)) &&
          !waiting) {
        waiting = true;
        // print(scanData.code.substring(4));
        // busData.busId = scanData.code.substring(4);
        QrCode = scanData.code.substring(4);
        docSnapshot = await collection.doc(QrCode).get();
      }
      setState(() {
        if (docSnapshot!.exists) {
          Map data = (docSnapshot.data() as Map);
          var route = (data['route'] as Map);
          // print(route);
          // waiting = false;
          qrController!.pauseCamera();
          Navigator.of(context).pushReplacementNamed('/RouteTimeline',
              arguments: RouteArguments(route));
        } else {
          print('invalid qr code');
          waiting = false;
        }
      });
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    qrController!.pauseCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Theme.of(context).accentColor,
            borderRadius: 10,
            borderLength: 20,
            borderWidth: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.8,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    await qrController!.flipCamera();
                  },
                  child: Icon(Icons.cameraswitch_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    await qrController!.toggleFlash();
                    setState(() => flashOn = !flashOn);
                  },
                  child: Icon(flashOn ? Icons.flash_off : Icons.flash_on),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.bug_report_outlined),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}

var docSnapshot;
