import 'package:flutter/material.dart';
import 'package:test1/customizing_widgets/customizing.dart';
import 'package:test1/settings_widgets/guide.dart';
import 'package:test1/settings_widgets/notice.dart';
import 'package:test1/settings_widgets/service_terms.dart';
import 'package:test1/settings_widgets/location_terms.dart';
import 'package:test1/settings_widgets/privacy_terms.dart';
import 'package:test1/settings_widgets/inquiry.dart';
import 'package:test1/user_widgets/my_post.dart';
import 'package:provider/provider.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'package:test1/login_widgets/login_ui.dart';
import 'package:test1/login_widgets/find_password.dart';

class SettingsUI extends StatefulWidget {
  const SettingsUI({super.key});

  @override
  _SettingsUIState createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  Widget sectionTitle(String title) {
    return Container(
      decoration: const BoxDecoration(color: Colors.grey),
      width: double.infinity,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget settingsOption(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        width: double.infinity,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: const TextStyle(fontSize: 15)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('설정',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  sectionTitle("서비스 설정"),
                  settingsOption("위젯 설정", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Customizing()));
                  }),
                  sectionTitle("고객 지원"),
                  settingsOption("어플 사용 가이드", onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Guide()));
                  }),
                  settingsOption("공지 사항", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Notice()));
                  }),
                  settingsOption(
                    "문의하기",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Inquiry()));
                    },
                  ),
                  settingsOption(
                    "작성 글",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyPost()));
                    },
                  ),
                  sectionTitle("약관 및 정책"),
                  settingsOption("서비스 이용약관", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Service_Terms()));
                  }),
                  settingsOption("위치 정보 이용 약관", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Location_Terms()));
                  }),
                  settingsOption("개인정보 처리방침", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Privacy_Terms()));
                  }),
                  sectionTitle("앱 정보"),
                  settingsOption("앱 버전 0.0.1"),
                  sectionTitle("계정 관리"),
                  settingsOption("비밀번호 변경", onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPasswordScreen()));
                  }),
                  settingsOption("계정 삭제", onTap: () {
                    _showDeleteAccountDialog();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60.0,
        color: Colors.green,
        child: Image.asset(
          'assets/images/광고3.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

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
                    const SnackBar(content: Text('비밀번호가 틀렸습니다.')), //오류 메시지
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
