import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:test1/login_widgets/login_ui.dart';

class InfoPage extends StatefulWidget {
  final User user;

  const InfoPage({Key? key, required this.user}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool service_check = false;
  bool location_check = false;
  bool privacy_check = false;

  //약관을 보여주는 함수
  Future<String> loadTerms(String filename) async {
    return await rootBundle.loadString('assets/terms/$filename');
  }

  void _showTerms(String filename, String title) async {
    String terms = await loadTerms(filename);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(terms),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '회원 정보 및 약관',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '전화번호'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '닉네임'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: '출생연도'),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title: InkWell(
                onTap: () => _showTerms('service_terms.txt', '서비스 이용약관'),
                child: Text('서비스 이용약관 동의'),
              ),
              value: service_check,
              onChanged: (bool? newValue) {
                setState(() {
                  service_check = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: InkWell(
                onTap: () => _showTerms('location_terms.txt', '위치정보 이용약관'),
                child: Text('위치정보 이용약관 동의'),
              ),
              value: location_check,
              onChanged: (bool? newValue) {
                setState(() {
                  location_check = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: InkWell(
                onTap: () => _showTerms('privacy_terms.txt', '개인정보 처리방침'),
                child: Text('개인정보 처리방침 동의'),
              ),
              value: privacy_check,
              onChanged: (bool? newValue) {
                setState(() {
                  privacy_check = newValue!;
                });
              },
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                // 모든 정보가 입력되었는지 확인
                if (_phoneController.text.isEmpty ||
                    _nicknameController.text.isEmpty ||
                    _ageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('모든 정보를 입력하세요.'),
                      backgroundColor: Color.fromARGB(255, 112, 48, 48),
                    ),
                  );
                } else if (!service_check ||
                    !location_check ||
                    !privacy_check) {
                  //이거 적용 안 됐음
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('모든 약관에 동의해야 합니다.'),
                      backgroundColor: Color.fromARGB(255, 112, 48, 48),
                    ),
                  );
                } else {
                  // 여기에서 추가 정보를 Firestore에 저장하고 Interface 페이지로 이동
                  _saveAdditionalInfo();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginUI(),
                    ),
                  );
                }
              },
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  // 추가 정보를 Firestore에 저장하는 함수
  void _saveAdditionalInfo() {
    final phone = _phoneController.text.trim();
    final nickname = _nicknameController.text.trim();
    final age = _ageController.text.trim(); //약관 3개도 추가해야함

    // 나이와 성별이 비어있을 경우 디폴트 값 설정
    final int parsedAge = age.isEmpty ? 0 : int.tryParse(age) ?? 0;

    // Firestore에 추가 정보 저장
    FirebaseFirestore.instance.collection('Users').doc(widget.user.uid).update({
      'phone': phone,
      'nickname': nickname,
      'age': parsedAge,
      'point': 0,
      'service_check': service_check,
      'location_check': location_check,
      'privacy_check': privacy_check
    }).then((value) {
      print('Additional info saved to Firestore');
    }).catchError((error) {
      print('Error saving additional info: $error');
    });
  }
}