import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinAccount extends StatefulWidget {
  const JoinAccount({super.key});

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
      return;
    }

    try {
      final newUser = await _authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      newUser.user?.updateDisplayName(name);
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
                            decoration:
                                const InputDecoration(labelText: 'Enter name'),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          TextField(
                            controller: _emailController,
                            autofocus: true,
                            decoration:
                                const InputDecoration(labelText: 'Enter email'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 80,
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
                            decoration: const InputDecoration(
                                labelText: 'Enter password'),
                            keyboardType: TextInputType.text,
                            obscureText: true, // 비밀번호 안보이도록 하는 것
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                                labelText: 'Comfirm password'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            // 비밀번호 안보이도록 하는 것
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          ButtonTheme(
                            minWidth: 100.0,
                            height: 50.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context)
                                            .primaryColorDark), // 버튼의 배경색
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16.0), // 버튼의 모서리를 둥글게 만듭니다.
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
