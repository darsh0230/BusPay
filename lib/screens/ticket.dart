import 'package:flutter/material.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class TicketArguments {
  int? adult = 0;
  int? child = 0;
  int? ticketPrice = 0;
  String? stRoute = '';
  String? endRoute = '';
  String? ticketId = '';

  TicketArguments(
      {this.adult,
      this.child,
      this.ticketPrice,
      this.stRoute,
      this.endRoute,
      this.ticketId});
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    double _fontSize = 16.0;
    final args = ModalRoute.of(context)!.settings.arguments as TicketArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              color: Colors.white,
              elevation: 10.0,
              borderRadius: BorderRadius.circular(12.0),
              shadowColor: Color(0x802196F3),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                // margin: ,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      _richText('Receipt Id: ', args.ticketId, 20.0),
                      SizedBox(
                        height: 30.0,
                      ),
                      _richText('FROM: ', args.stRoute, _fontSize),
                      SizedBox(
                        height: 10.0,
                      ),
                      _richText('TO: ', args.endRoute, _fontSize),
                      SizedBox(
                        height: 10.0,
                      ),
                      _richText('ADULT: ', args.adult.toString(), _fontSize),
                      SizedBox(
                        height: 10.0,
                      ),
                      _richText('CHILD: ', args.child.toString(), _fontSize),
                      SizedBox(
                        height: 10.0,
                      ),
                      _richText('TOTAL FEE: ', args.ticketPrice.toString(),
                          _fontSize),
                      SizedBox(
                        height: 10.0,
                      ),
                      _richText(
                          'PAID SUCCESSFULLY THROUGH: ', 'WALLET', _fontSize),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 100.0,
                child: TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.blue)),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        // width: 90.0,
                        // height: 40.0,
                        // color: Colors.amber,
                        child: Text('Maps'))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _richText(name, args, fontSize) {
  return RichText(
    text: new TextSpan(
      style: new TextStyle(
        fontSize: fontSize,
        color: Colors.black,
      ),
      children: <TextSpan>[
        new TextSpan(text: name),
        new TextSpan(
            text: args, style: new TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
