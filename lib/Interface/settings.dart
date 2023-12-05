import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test1/Board/my_board.dart';
import 'package:test1/Help/guide.dart';
import 'package:test1/Help/inquiry_list.dart';
import 'package:test1/Help/notice.dart';
import 'package:test1/Interface/menu.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/Terms/location_terms.dart';
import 'package:test1/Terms/privacy_terms.dart';
import 'package:test1/Terms/service_terms.dart';
import 'package:test1/User/login.dart';
import 'package:test1/User/reset_passwd.dart';
import 'package:test1/main.dart';

//설정 페이지
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController mainStationController = TextEditingController();
  //메인스테이션 설정
  Future<void> _changeMainStationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        return AlertDialog(
          title: const Text(
            '게시판 설정',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: mainStationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '취소',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '설정',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                if (await userProvider
                    .updateMainStation(int.parse(mainStationController.text))) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                } else {
                  showSnackBar(context, const Text("존재하지 않는 역입니다"));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    String password = ''; //비밀번호 저장 변수
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
                    password = value; //비밀번호 확인
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
                      builder: (context) => const LogIn(),
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

  //설정 메뉴 타일 위젯
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

  //설정 메뉴 탭 액션 구현 메소드
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

  UserProvider userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
    updateUserProviderData();
  }

  //사용자 정보 업데이트하는 메소드 -> 로그인 하면서 사용자 정보 패치
  Future<void> updateUserProviderData() async {
    await userProvider.fetchUserInfo();
    setState(() {
      mainStation = userProvider.mainStation;
    });
  }

  String mainStation = "";

  //위젯
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              currentUI = "home";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Menu(),
                ),
              );
            },
          ),
          title: const Text('설정',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                    settingsOption("위젯 설정     현재 설정 역 : $mainStation",
                        onTap: () {
                      _changeMainStationDialog();
                    }),
                    sectionTitle("고객 지원"),
                    settingsOption("어플 사용 가이드", onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Guide()));
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
                                builder: (context) => const InquiryList()));
                      },
                    ),
                    settingsOption(
                      "작성 글",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyBoard()));
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
                              builder: (context) => const ResetPassword()));
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
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          height: 60.0,
          child: Image.asset(
            'assets/images/광고3.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
