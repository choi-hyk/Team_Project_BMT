import 'package:flutter/material.dart';
import 'package:test1/settings_widgets/setting_account_page.dart';

//계정 정보에서 포인트, 스토어, 자기가 작성한 게시글, 즐겨찾기, 리워드 목록을 볼수있게 구현해야됨

//사용자 프로필 위젯
class UserProfileWidget extends StatelessWidget {
  final String name;
  final String email;
  final String profileImageUrl;

  const UserProfileWidget({
    super.key,
    required this.name,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.0)),
      width: double.infinity,
      height: 260,
      child: Column(
        children: [
          const SizedBox(
            height: 13.0,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(profileImageUrl),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6.5),
          Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6.5),
          const Text(
            "point : 20p",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingAccount(),
                    ),
                  );
                },
                child: const Text(
                  "계정 설정",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              //로그아웃 버튼으로 구현해야됨
              const Text(
                "로그아웃",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountUI extends StatefulWidget {
  const AccountUI({super.key});

  @override
  State<AccountUI> createState() => AccountUIState();
}

class AccountUIState extends State<AccountUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ), // 뒤로 가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼을 누르면 현재 화면에서 빠져나감
          },
        ),
        title: const Text(
          '계정 정보',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const UserProfileWidget(
            name: "CHOI HYUK",
            email: "8176chhk@naver.com",
            profileImageUrl: "assets/images/사용자 프로필.png",
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: 500,
                height: 660,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: 500,
                        height: 150,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "작성 글",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                        height: 150,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "즐겨 찾기",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                        height: 150,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "스토어",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                        height: 150,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "기록",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}