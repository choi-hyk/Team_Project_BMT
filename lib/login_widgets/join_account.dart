import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD

class JoinAccount extends StatefulWidget {
  const JoinAccount({super.key});
=======
import 'package:test1/login_widgets/info_page.dart';

class JoinAccount extends StatefulWidget {
  const JoinAccount({Key? key}) : super(key: key);
>>>>>>> 0e2033c (로그인 어쩌고 수정)

  @override
  State<JoinAccount> createState() => _JoinAccountState();
}

class _JoinAccountState extends State<JoinAccount> {
  final _authentication = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

<<<<<<< HEAD
  //회원가입 함수
  Future<void> _handleJoinAccount() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmpassword = _confirmPasswordController.text;

    if (password != confirmpassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호가 일치하지 않습니다. 비밀번호를 다시 설정하세요.'),
          backgroundColor: Color.fromARGB(255, 112, 48, 48),
        ),
      );
=======
  // 회원가입 함수
  Future<void> _handleJoinAccount() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 입력값 유효성 검사
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('모든 필드를 입력하세요.');
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackBar('비밀번호가 일치하지 않습니다.');
>>>>>>> 0e2033c (로그인 어쩌고 수정)
      return;
    }

    try {
      final newUser = await _authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
<<<<<<< HEAD
      newUser.user?.updateDisplayName(name);
      await addUserToFirestore(newUser.user!); //디비 연동

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원 가입이 성공적으로 완료되었습니다.'),
          backgroundColor: Color.fromARGB(255, 112, 48, 48),
        ),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('보안 강도가 낮습니다. 비밀번호를 다시 설정하세요.'),
            backgroundColor: Color.fromARGB(255, 112, 48, 48),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이미 존재하는 이메일입니다.'),
            backgroundColor: Color.fromARGB(255, 112, 48, 48),
          ),
        );
      }
    }
  }

  //회원가입 후 디비에 추가하는 함수
  Future<void> addUserToFirestore(User user) async {
=======

      await addUserToFirestore(newUser.user!, name); // 디비 연동

      await Future.delayed(Duration.zero);

      // 추가 정보 입력 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Builder(
            builder: (context) => InfoPage(user: newUser.user!),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(_getErrorMessage(e.code));
    }
  }

  // 회원가입 후 디비에 추가하는 함수
  Future<void> addUserToFirestore(User user, String name) async {
>>>>>>> 0e2033c (로그인 어쩌고 수정)
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('Users');

    return users
        .doc(user.uid)
        .set({
<<<<<<< HEAD
          'User_ID': user.uid, //사용자 ID 가져오기
          'email': user.email, //사용자 이메일 가져오기
=======
          'User_ID': user.uid,
          'name': name, // 사용자 이름 추가
          'email': user.email,
          'created_at': FieldValue.serverTimestamp(),
>>>>>>> 0e2033c (로그인 어쩌고 수정)
        })
        .then((value) => print("User Added to Firestore"))
        .catchError((error) => print("Failed to add user: $error"));
  }

<<<<<<< HEAD
=======
  // 에러 메시지를 보여주는 스낵바
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 112, 48, 48),
      ),
    );
  }

  // FirebaseAuthException 코드에 따라 메시지 반환
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return '보안 강도가 낮습니다. 비밀번호를 다시 설정하세요.';
      case 'email-already-in-use':
        return '이미 존재하는 이메일입니다.';
      default:
        return '회원가입에 실패했습니다. 다시 시도하세요.';
    }
  }

>>>>>>> 0e2033c (로그인 어쩌고 수정)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
<<<<<<< HEAD
          ), // 뒤로 가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼을 누르면 현재 화면에서 빠져나감
=======
          ),
          onPressed: () {
            Navigator.pop(context);
>>>>>>> 0e2033c (로그인 어쩌고 수정)
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
          FocusScope.of(context).unfocus();
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
                            decoration: const InputDecoration(labelText: '이름'),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
<<<<<<< HEAD
                            height: 50,
=======
                            height: 20,
>>>>>>> 0e2033c (로그인 어쩌고 수정)
                          ),
                          TextField(
                            controller: _emailController,
                            autofocus: true,
                            decoration: const InputDecoration(labelText: '이메일'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
<<<<<<< HEAD
                            height: 50,
=======
                            height: 20,
>>>>>>> 0e2033c (로그인 어쩌고 수정)
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
<<<<<<< HEAD
                            obscureText: true, // 비밀번호 안보이도록 하는 것
                          ),
                          const SizedBox(
                            height: 30.0,
=======
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 20.0,
>>>>>>> 0e2033c (로그인 어쩌고 수정)
                          ),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration:
                                const InputDecoration(labelText: '비밀번호 확인'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
<<<<<<< HEAD
                            // 비밀번호 안보이도록 하는 것
                          ),
                          const SizedBox(
                            height: 70,
=======
                          ),
                          const SizedBox(
                            height: 30,
>>>>>>> 0e2033c (로그인 어쩌고 수정)
                          ),
                          ButtonTheme(
                            minWidth: 100.0,
                            height: 50.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
<<<<<<< HEAD
                                        Theme.of(context)
                                            .primaryColorDark), // 버튼의 배경색
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16.0), // 버튼의 모서리를 둥글게 만듭니다.
=======
                                  Theme.of(context).primaryColorDark,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
>>>>>>> 0e2033c (로그인 어쩌고 수정)
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await _handleJoinAccount();
                              },
                              child: const Text(
                                "계정 등록",
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
<<<<<<< HEAD
              )
=======
              ),
>>>>>>> 0e2033c (로그인 어쩌고 수정)
            ],
          ),
        ),
      ),
    );
  }
}
