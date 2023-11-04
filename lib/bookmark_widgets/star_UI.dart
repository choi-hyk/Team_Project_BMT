import 'package:flutter/material.dart';

class StarUI extends StatefulWidget {
  const StarUI({super.key});

  @override
  State<StarUI> createState() => _StarUIState();
}

class _StarUIState extends State<StarUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13.0),
          topRight: Radius.circular(13.0),
        ),
      ),
      width: 379.5,
      height: 640.0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 500,
              height: 110,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "집(회사, 학교)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 500,
              height: 110,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "즐겨찾기 경로",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0)),
              width: 500,
              height: 110,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "즐겨찾기 역(호선)",
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
