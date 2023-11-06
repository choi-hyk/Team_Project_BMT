import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/interface.dart';
import 'package:test1/login_widgets/find_account.dart';
import 'package:test1/login_widgets/join_account.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LogInState();
}

class _LogInState extends State<LoginUI> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<User?> _handleSignIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isEmpty) {
      showSnackBar(
        context,
        const Text("이메일을 입력하세요."),
      );
      return null;
    } else if (password.isEmpty) {
      showSnackBar(context, const Text("비밀번호를 입력하세요."));
      return null;
    }

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      return user;
    } catch (e) {
      showSnackBar(context, const Text("아이디 또는 비밀번호가 올바르지 않습니다."));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10.0)),
            width: 500,
            height: 250,
            child: const Center(child: Text("앱 아이콘 들어갈 곳")),
          ),
          GestureDetector(
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
                                decoration: const InputDecoration(
                                    labelText: 'Enter email'),
                                keyboardType: TextInputType.emailAddress,
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
                                    User? user = await _handleSignIn();
                                    if (user != null) {
                                      // 로그인 성공
                                      print('로그인 성공: ${user.email}');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NextPage()));
                                    } else {
                                      // 로그인 실패
                                      print('로그인 실패');
                                    }
                                  },
                                  child: const Icon(
                                    Icons.login_sharp,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all<Color>(Theme.of(context)
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const JoinAccount(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "회원 가입",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all<Color>(Theme.of(context)
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const FindAccount(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "계정 찾기",
                                      ),
                                    ),
                                  ),
                                ],
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
        ],
      ),
    );
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: const Color.fromARGB(255, 112, 48, 48),
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InterFace();
  }
}
