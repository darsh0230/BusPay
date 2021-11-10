import 'package:buspay/services/bus_data.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RouteTimeline extends StatefulWidget {
  const RouteTimeline({Key? key}) : super(key: key);

  @override
  _RouteTimelineState createState() => _RouteTimelineState();
}

class RouteArguments {
  var routes;
  RouteArguments(this.routes);
}

class _RouteTimelineState extends State<RouteTimeline> {
  List<bool> isFocused = [true];
  int startRoute = 0;
  int endRoute = -1;

  Widget _timelineTile(int index, route, bool isFirst, bool isLast) {
    // print(route.isfocused);
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
          color: !route.isfocused[index]
              ? Colors.grey
              : route.startRoute == index
                  ? Colors.blue
                  : route.endRoute == index
                      ? Colors.green
                      : Colors.blue.shade100,
          padding: EdgeInsets.all(5)),
      beforeLineStyle: LineStyle(
        color: index - 1 < 0
            ? Colors.black54
            : !route.isfocused[index]
                ? Colors.black54
                : route.isfocused[index - 1]
                    ? Colors.blue.shade100
                    : Colors.black54,
        // thickness: 10
      ),
      afterLineStyle: LineStyle(
        color: index + 1 >= route.stopNames.length
            ? Colors.black54
            : !route.isfocused[index]
                ? Colors.black54
                : route.isfocused[index + 1]
                    ? Colors.blue.shade100
                    : Colors.black54,
        // thickness: 10
      ),
      endChild: GestureDetector(
        onTap: () {
          for (int i = 0; i < route.stopNames.length; i++) {
            if ((i >= route.startRoute && i <= index) ||
                (i <= route.startRoute && i >= index)) {
              route.isfocused[i] = true;
            } else {
              route.isfocused[i] = false;
            }
          }
          route.endRoute = index;
          isFocused = route.isfocused;
          startRoute = route.startRoute;
          endRoute = route.endRoute;
          setState(() {});
          // print(route.isfocused);
        },
        onLongPress: () {
          route.startRoute = index;
          for (int i = 0; i < route.stopNames.length; i++) {
            if ((i >= route.startRoute && i <= route.endRoute) ||
                (i <= route.startRoute && i >= route.endRoute)) {
              route.isfocused[i] = true;
            } else {
              route.isfocused[i] = false;
            }
          }
          isFocused = route.isfocused;
          startRoute = route.startRoute;
          endRoute = route.endRoute;
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 80),
            // width: MediaQuery.of(context).size.width,
            color: Colors.white,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.stopNames[index],
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as RouteArguments;
    BusRoute route = BusRoute(args.routes);
    while (isFocused.length < route.isfocused.length) {
      isFocused.add(false);
    }
    route.isfocused = isFocused;
    route.startRoute = startRoute;
    route.endRoute = endRoute;
    print(route.isfocused);
    return Scaffold(
      appBar: AppBar(
        title: Text('Routes'),
      ),
      body: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // BusRoute route = BusRoute(args.routes);
                return _timelineTile(index, route, index == 0 ? true : false,
                    index == route.stopNames.length - 1 ? true : false);
              },
            ),
          ),
        ),
        Container(
            // constraints: const BoxConstraints(minHeight: 80),
            // color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.1,
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // color: Colors.black,
                  width: MediaQuery.of(context).size.height * 0.21,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Rs.${((startRoute - endRoute) * 5).abs()}',
                          style: TextStyle(fontSize: 20.0)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.amber,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Book Ticket',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Text('>Pay Now')
                      ],
                    ),
                  ),
                )
              ],
            )),
      ]),
    );
  }
}