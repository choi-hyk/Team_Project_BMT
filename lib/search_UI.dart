import 'package:flutter/material.dart';

//길찾기 UI
//최단 시간, 최소 비용, 최적 경로 제공 -> 사용자 설정으로 순서 변경 가능
//사용자 설정 UI 제공 -> default 즐겨찾기 경로, 사용자 설정으로 변경 가능
class SearchUI extends StatefulWidget {
  const SearchUI({super.key});

  @override
  State<SearchUI> createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 379.5,
      height: 640.0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                hintText: '출발',
              ),
            ),
            const SizedBox(
              height: 6.5,
            ),
            const TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                hintText: '도착',
              ),
            ),
            const SizedBox(
              height: 13.0,
            ),
//-------------경로 컨테이너---------------------------------------------------------------//
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 500,
              height: 100,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "최소 비용",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 6.5,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 500,
              height: 100,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "최단 시간",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 6.5,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 500,
              height: 100,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "최적 경로",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 6.5,
            ),
//-------------사용자 설정 컨테이너---------------------------------------------------------------//
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 500,
              height: 130,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "즐겨찾기 경로",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
