import 'package:flutter/material.dart';
import 'package:test1/interface.dart';
import 'package:test1/main.dart';
import 'package:test1/provider_code/user_provider.dart';

class ProvReward extends StatefulWidget {
  const ProvReward({super.key});

  @override
  State<ProvReward> createState() => _ProvRewardState();
}

class _ProvRewardState extends State<ProvReward> {
  UserProvider userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
    currentUI = 'home';
    _updateUserPointAfterDelay();
  }

  void _updateUserPointAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3), () {
      // 유저 아이디에 100 포인트 추가
      userProvider.addPointsToUser();
      // 3초 후에 화면 전환
      _navigateToOtherScreen();
    });
  }

  void _navigateToOtherScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InterFace()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text("앱 아이콘 들어갈곳"),
          const SizedBox(
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Theme.of(context).primaryColor),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      "감사합니다!",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      "100P 를 지급해드렸습니다!",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
