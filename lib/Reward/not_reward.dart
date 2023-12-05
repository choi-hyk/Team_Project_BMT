import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/main.dart';

class NotReward extends StatefulWidget {
  const NotReward({super.key});

  @override
  State<NotReward> createState() => _NotRewardState();
}

class _NotRewardState extends State<NotReward> {
  @override
  void initState() {
    super.initState();
    currentUI = 'home';
    _updateUserPointAfterDelay();
  }

  void _navigateToBack() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _updateUserPointAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      //유저 아이디에 100 포인트 추가
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.addPointsToUser();
      //유저 아이디에 혼잡도 제보 1 추가
      userProvider.addCountToUser();
      //3초 후에 화면 전환
      _navigateToBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserInfo();
    // ignore: deprecated_member_use
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
                    const Center(
                      child: Text(
                        "혼잡도 정보",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Center(
                      child: Text(
                        "제보 완료",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor),
                      ),
                    ),
                    Text(
                      "오늘 혼잡도 정보를 총 ${userProvider.count}회 제공하셨어요!",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorLight),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "오늘은 아쉽지만 더이상 리워드를 못받아요...",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark),
            ),
            Text(
              "잠시 후 이전 화면으로 이동합니다",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark),
            ),
          ],
        ),
      ),
    );
  }
}
