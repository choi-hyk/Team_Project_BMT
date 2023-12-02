import 'package:flutter/material.dart';
import 'package:test1/settings_widgets/guide.dart';
import 'package:test1/settings_widgets/notice.dart';
import 'package:test1/settings_widgets/service_terms.dart';
import 'package:test1/settings_widgets/location_terms.dart';
import 'package:test1/settings_widgets/privacy_terms.dart';

class SettingsUI extends StatefulWidget {
  @override
  _SettingsUIState createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  Widget sectionTitle(String title) {
    return Container(
      decoration: const BoxDecoration(color: Colors.grey),
      width: double.infinity,
      height: 40,
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
        height: 50,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            sectionTitle("서비스 설정"),
            settingsOption("위젯 설정"),
            sectionTitle("고객 지원"),
            settingsOption("어플 사용 가이드", onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Guide()));
            }),
            settingsOption("공지 사항", onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Notice()));
            }),
            settingsOption("문의하기"),
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
            settingsOption("앱 버전 0.0.1")
          ],
        ),
      ),
    );
  }
}
