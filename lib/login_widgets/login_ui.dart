import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/interface.dart';
import 'package:test1/login_widgets/find_password.dart';
import 'package:test1/login_widgets/join_account.dart';
import 'package:test1/main.dart';
import 'package:test1/provider_code/data_provider.dart';
import 'package:test1/provider_code/user_provider.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  State<LoginUI> createState() => _LogInState();
}

class _LogInState extends State<LoginUI> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  DataProvider dataProvider = DataProvider(); //프로바이더 객체 변수

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
                                decoration:
                                    const InputDecoration(labelText: '이메일'),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextField(
                                controller: _passwordController,
                                decoration:
                                    const InputDecoration(labelText: '비밀번호'),
                                keyboardType: TextInputType.text,
                                obscureText: true,
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
                                      Theme.of(context).primaryColorDark,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var userProvider = context.read<
                                        UserProvider>(); //user_provider에서 가져오기

                                    String? errorMessage =
                                        await userProvider.handleSignIn(
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    if (!mounted) return; //현재 위젯이 마운트되었는지 확인

                                    if (errorMessage == null &&
                                        userProvider.user != null) {
                                      // 로그인 성공 및 user가 null이 아닌 경우
                                      print(
                                          '로그인 성공: ${userProvider.user!.email}');
                                      currentUI = 'home';
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NextPage(
                                            currentUser: userProvider
                                                .user!, // null이 아닌 것이 보장된 User 객체
                                            dataProvider: dataProvider,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // 로그인 실패 또는 사용자 정보 없음
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(errorMessage ?? "로그인 오류")),
                                      );
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
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColorDark,
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16.0,
                                            ),
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
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColorDark,
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ResetPasswordScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "비밀번호 찾기",
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

class NextPage extends StatelessWidget {
  final User currentUser;
  final DataProvider dataProvider;

  const NextPage({
    Key? key,
    required this.currentUser,
    required this.dataProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InterFace(
      currentUser: currentUser,
    );
  }
}
