import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FindAccount extends StatefulWidget {
  const FindAccount({super.key});

  @override
  State<FindAccount> createState() => _FindAccountState();
}

class _FindAccountState extends State<FindAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  Future<void> _handlePasswordReset() async {
    final email = _emailController.text;

    try {
      final result = await _auth.fetchSignInMethodsForEmail(email);
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('등록된 사용자를 찾을 수 없습니다.'),
            backgroundColor: Color.fromARGB(255, 112, 48, 48),
          ),
        );
      } else {
        await _auth.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('비밀번호 재설정 링크가 이메일로 전송되었습니다.'),
            backgroundColor: Color.fromARGB(255, 112, 48, 48),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이메일로 등록된 사용자를 찾을 수 없습니다.'),
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
          '게정 찾기',
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
                            controller: _emailController,
                            autofocus: true,
                            decoration:
                                const InputDecoration(labelText: 'Enter email'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 50),
                          Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "비밀번호 재설정을 위해 이메일을 입력하십시오. 해당 이메일에서 비밀번호 재설정 링크를 받은 후 비밀번호를 재설정 하십시오."),
                            ),
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
                                await _handlePasswordReset();
                              },
                              child: const Text(
                                "이메일 발송",
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
