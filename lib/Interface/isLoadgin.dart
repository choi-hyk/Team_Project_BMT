import 'package:flutter/material.dart';

class isLoad extends StatefulWidget {
  const isLoad({super.key});

  @override
  State<isLoad> createState() => _isLoadState();
}

class _isLoadState extends State<isLoad> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //뒤로 가기 버튼 무시하고 아무 동작 안 함
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              "assets/images/Fast2.png",
              fit: BoxFit.contain,
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 90,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text(
                        "is Loading...",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
