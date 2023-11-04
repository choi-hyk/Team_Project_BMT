import 'package:flutter/material.dart';
import 'package:test1/settings_widgets/setting_account_page.dart';

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
        backgroundColor: Theme.of(context).primaryColorLight,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingAccount(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Theme.of(context).cardColor, // 텍스트와 아이콘의 색상
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // 패딩 설정
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // 버튼의 모서리를 둥글게 만듭니다.
                ),
              ),
              child: const Text(
                '계정 설정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
              ),
            ),
            const SizedBox(height: 6.5),
            ElevatedButton(
              onPressed: () {
                // 여기에 도움말을 위한 페이지로 이동하는 코드 추가
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Theme.of(context).cardColor, // 텍스트와 아이콘의 색상
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // 패딩 설정
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // 버튼의 모서리를 둥글게 만듭니다.
                ),
              ),
              child: const Text(
                '도움말',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
              ),
            ),
            const SizedBox(height: 6.5),
            ElevatedButton(
              onPressed: () {
                // 여기에 공지 사항을 위한 페이지로 이동하는 코드 추가
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Theme.of(context).cardColor, // 텍스트와 아이콘의 색상
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // 패딩 설정
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // 버튼의 모서리를 둥글게 만듭니다.
                ),
              ),
              child: const Text(
                '공지 사항',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
              ),
            ),
            const SizedBox(height: 6.5),
            ElevatedButton(
              onPressed: () {
                // 여기에 앱 정보를 위한 페이지로 이동하는 코드 추가
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Theme.of(context).cardColor, // 텍스트와 아이콘의 색상
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // 패딩 설정
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // 버튼의 모서리를 둥글게 만듭니다.
                ),
              ),
              child: const Text(
                '앱 정보',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
