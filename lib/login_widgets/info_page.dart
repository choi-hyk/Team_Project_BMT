import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          '추가 정보',
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
            const SizedBox(height: 40),
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
    final age = _ageController.text.trim();

    // 나이와 성별이 비어있을 경우 디폴트 값 설정
    final int parsedAge = age.isEmpty ? 0 : int.tryParse(age) ?? 0;

    // Firestore에 추가 정보 저장
    FirebaseFirestore.instance.collection('Users').doc(widget.user.uid).update({
      'phone': phone,
      'nickname': nickname,
      'age': parsedAge,
      'rewardpoint': 0,
    }).then((value) {
      print('Additional info saved to Firestore');
    }).catchError((error) {
      print('Error saving additional info: $error');
    });
  }
}
