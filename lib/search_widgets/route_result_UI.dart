import 'package:flutter/material.dart';

class RouteResults extends StatefulWidget {
  final String startStation;
  final String arrivStation;
  const RouteResults(
      {super.key, required this.startStation, required this.arrivStation});

  @override
  State<RouteResults> createState() => _RouteResultsState();
}

class _RouteResultsState extends State<RouteResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 90,
          height: 35,
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              "앱 추천 경로",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 90,
          height: 35,
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              "최단 시간",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 90,
          height: 35,
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              "최소 비용",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]),
    );
  }
}
