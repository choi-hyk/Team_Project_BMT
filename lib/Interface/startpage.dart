import 'package:flutter/material.dart';
import 'package:test1/User/login.dart';

//앱 시작하고 처음 진입하는 페이지 -> 로그인 텍스트 눌러서 로그인페이지로 이동 가능
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 175, 222, 227),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fast",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).cardColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogIn(),
                      ),
                    );
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/Fast2.png",
            fit: BoxFit.contain,
            width: 200,
            height: 200,
          ),
          Text(
            "지하철 타고 기프티콘 받자!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
                color: Theme.of(context).primaryColorDark),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Do it subway,",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColorDark),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                "Fast",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).cardColor),
              ),
            ],
          ),
          Text(
            "혼잡도 정보",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Theme.of(context).primaryColorLight),
          ),
          Text(
            "제공하고",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).cardColor),
          ),
          Text(
            "포인트를 획득하세요!",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).cardColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 350,
            height: 307,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              color: Color.fromARGB(255, 163, 201, 205),
            ),
            child: Image.asset(
              "assets/images/리워드.png",
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
