import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'package:test1/login_widgets/login_ui.dart';
import 'package:test1/user_widgets/written_page.dart';
//계정 정보에서 포인트, 스토어, 자기가 작성한 게시글, 즐겨찾기, 리워드 목록을 볼수있게 구현해야됨

//사용자 프로필 위젯
class UserProfileWidget extends StatefulWidget {
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
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
//계정을 삭제하는 화면을 보여주는 함수
  Future<void> _showDeleteAccountDialog() async {
    String password = ''; // 비밀번호 저장 변수
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        return AlertDialog(
          title: const Text('계정 삭제'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('정말 계정을 삭제하시겠습니까?'),
                const Text('계속하려면 비밀번호를 입력하세요.'),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value; // 비밀번호 업데이트
                  },
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('삭제'),
              onPressed: () async {
                String? result =
                    await userProvider.handleDeleteAccount(password);

                if (result == null) {
                  //비밀번호 일치, 성공 메시지 표시 후 로그인 화면으로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('계정이 삭제되었습니다.')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginUI(),
                    ),
                  );
                } else {
                  //비밀번호 불일치
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('비밀번호가 틀렸습니다.')), //오류 메시지
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); //사용자 정보 사용을 위해

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      width: double.infinity,
      height: 260,
      child: Column(
        children: [
          const SizedBox(
            height: 13.0,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(widget.profileImageUrl),
          ),
          const SizedBox(height: 14),
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6.5),
          Text(
            widget.email,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6.5),
          Text(
            "보유 포인트 : ${userProvider.point}",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _showDeleteAccountDialog();
                },
                child: const Text(
                  "계정 삭제",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () async {
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  await userProvider.handleSignOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginUI(),
                    ),
                    (Route<dynamic> route) => false, //네비게이터 초기화
                  );
                },
                child: const Text(
                  "로그아웃",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
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
    final userProvider = Provider.of<UserProvider>(context); //사용자 정보 사용을 위해

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
          UserProfileWidget(
            name: userProvider.name,
            email: userProvider.email,
            profileImageUrl: "assets/images/사용자 프로필.png",
          ),
          const SizedBox(
            height: 6.5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: 500,
                height: 660,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: 500,
                        height: 150,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WrittenPage()),
                            );
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "작성 글",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
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
