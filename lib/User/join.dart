import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/User/info.dart';

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);
  @override
  State<Join> createState() => _JoinAccountState();
}

class _JoinAccountState extends State<Join> {
  final _authentication = FirebaseAuth.instance; //Authentication 인증 객체 생성
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //회원가입 함수
  Future<void> _handleJoinAccount() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    //입력값 유효성 검사
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('모든 필드를 입력하세요.');
      return;
    }
    if (password != confirmPassword) {
      _showErrorSnackBar('비밀번호가 일치하지 않습니다.');
      return;
    }
    try {
      final newUser = await _authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await addUserToFirestore(newUser.user!, name); //DB에 사용자 추가

      //추가 정보 입력 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Info(user: newUser.user!), //user 객체 넘겨주기
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(_getErrorMessage(e.code)); //에러 메시지 표시
    }
  }

  //DB에 사용자 정보를 추가하는 함수
  Future<void> addUserToFirestore(User user, String name) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('Users');

    return users
        .doc(user.uid)
        .set({
          'User_ID': user.uid,
          'name': name, // 사용자 이름 추가
          'email': user.email,
          'created_at': FieldValue.serverTimestamp(),
        })
        .then((value) => print("사용자 추가 완료"))
        .catchError((error) => print("사용자 추가 실패: $error"));
  }

  //에러 메시지를 보여주는 스낵바
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 112, 48, 48),
      ),
    );
  }

  //FirebaseAuthException 코드에 따라 메시지 반환
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return '보안 강도가 낮습니다. 비밀번호를 다시 설정하세요.';
      case 'email-already-in-use':
        return '이미 존재하는 이메일입니다.';
      default:
        return '회원가입 실패, 다시 시도하세요.';
    }
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
          '회원 가입',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); //화면 탭 시 키보드 숨김
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              Form(
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Builder(
                    builder: (context) {
                      return Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            autofocus: true,
                            decoration: const InputDecoration(labelText: '이름'),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: '이메일'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "6자리 이상의 비밀번호를 입력하십시오",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: '비밀번호'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration:
                                const InputDecoration(labelText: '비밀번호 확인'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ButtonTheme(
                            minWidth: 100.0,
                            height: 50.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColorDark,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await _handleJoinAccount(); //회원가입 처리
                              },
                              child: const Text(
                                "다음",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
