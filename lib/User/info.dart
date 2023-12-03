import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test1/User/login.dart';

class Info extends StatefulWidget {
  final User user;

  const Info({Key? key, required this.user}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool service_check = false;
  bool location_check = false;
  bool privacy_check = false;

  //약관을 가져오는 메소드
  Future<String> loadTerms(String filename) async {
    return await rootBundle.loadString('assets/terms/$filename');
  }

  //약관 화면을 보여주는 메소드
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
              child: const Text('닫기'),
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
      resizeToAvoidBottomInset: false,
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
            CheckboxListTile(
              title: InkWell(
                onTap: () => _showTerms('service_terms.txt', '서비스 이용약관'),
                child: const Text('서비스 이용약관 동의'),
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
                child: const Text('위치정보 이용약관 동의'),
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
                child: const Text('개인정보 처리방침 동의'),
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
                //에러 핸들링
                if (_phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('전화 번호를 입력하세요.'),
                      backgroundColor: Color.fromARGB(255, 112, 48, 48),
                    ),
                  );
                } else if (_phoneController.text.length != 11) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('전화번호가 올바른지 확인하세요.'),
                      backgroundColor: Color.fromARGB(255, 112, 48, 48),
                    ),
                  );
                } else if (_nicknameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('닉네임을 입력하세요.'),
                      backgroundColor: Color.fromARGB(255, 112, 48, 48),
                    ),
                  );
                } else if (!service_check ||
                    !location_check ||
                    !privacy_check) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('모든 약관에 동의해야 합니다.'),
                      backgroundColor: Color.fromARGB(255, 112, 48, 48),
                    ),
                  );
                } else {
                  _saveAdditionalInfo(); //추가 정보
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogIn(), //로그인 화면으로
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

  //추가 정보를 Firestore에 저장하는 함수
  void _saveAdditionalInfo() {
    final phone = _phoneController.text.trim();
    final nickname = _nicknameController.text.trim();

    //Firestore에 추가 정보 저장
    FirebaseFirestore.instance.collection('Users').doc(widget.user.uid).update({
      'phone': phone,
      'nickname': nickname,
      'point': 0,
      'service_check': service_check,
      'location_check': location_check,
      'privacy_check': privacy_check,
      'mainStation': 101,
      'count': 0
    }).then((value) {
      print('Additional info saved to Firestore');
    }).catchError((error) {
      print('Error saving additional info: $error');
    });
  }
}
