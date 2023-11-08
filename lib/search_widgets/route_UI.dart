import 'package:flutter/material.dart';

class RouteSearch extends StatefulWidget {
  const RouteSearch({super.key});

  @override
  State<RouteSearch> createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            width: double.infinity,
            height: 90,
          )
        ],
      ),
    );
  }
}
