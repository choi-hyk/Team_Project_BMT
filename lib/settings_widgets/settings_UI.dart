import 'package:flutter/material.dart';
import 'package:test1/settings_widgets/guide.dart';
import 'package:test1/settings_widgets/notice.dart';
import 'package:test1/settings_widgets/setting_account_page.dart';
import 'package:test1/settings_widgets/service_terms.dart';
import 'package:test1/settings_widgets/location_terms.dart';
import 'package:test1/settings_widgets/privacy_terms.dart';

//계정 설정 버튼 페이지만 만들고 내부 구성은 아직 안함. 나머지 버튼은 페이지말고 작게 팝업으로 띄울 예정

class SettingsUI extends StatefulWidget {
  const SettingsUI({Key? key}) : super(key: key);

  @override
  State<SettingsUI> createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
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
            '설정',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                width: double.infinity,
                height: 40,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "서비스 설정",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "위젯 설정",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                width: double.infinity,
                height: 40,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "계정 설정",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "계정 정보",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                width: double.infinity,
                height: 40,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "고객 지원",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Guide()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "어플 사용 가이드",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Notice()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "공지 사항",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "문의하기",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                width: double.infinity,
                height: 40,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "기타",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Service_Terms()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "서비스 이용약관",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Location_Terms()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "위치 정보 이용 약관",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 0.5, // 테두리 두께
                  ),
                ),
                width: double.infinity,
                height: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Privacy_Terms()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "개인정보 처리방침",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
