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
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "앱 추천 경로",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text("최단 시간"),
                  Text("최소 비용"),
                ]),
          )
        ],
      ),
    );
  }
}
