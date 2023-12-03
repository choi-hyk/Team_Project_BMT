import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/Provider/data_provider.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/User/reset_passwd.dart';
import 'package:test1/main.dart';
import 'package:test1/User/join.dart';
import 'package:test1/Interface/menu.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  //이메일과 비밀번호 입력하는 텍스트필드 컨트롤러 선언
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //프로바이더 객체 선언
  DataProvider dataProvider = DataProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            width: 500,
            height: 400,
            child: Center(
              child: Image.asset(
                "assets/images/Fast2.png",
                fit: BoxFit.contain,
                width: 300,
                height: 300,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    child: Container(
                      padding: const EdgeInsets.all(40.0),
                      child: Builder(
                        builder: (context) {
                          return Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                autofocus: true,
                                decoration:
                                    const InputDecoration(labelText: '이메일'),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextFormField(
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
                                          20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var userProvider = context.read<
                                        UserProvider>(); // user_provider에서 가져오기

                                    String? errorMessage =
                                        await userProvider.handleSignIn(
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    if (!mounted) return; //현재 위젯이 마운트되었는지 확인

                                    if (errorMessage == null &&
                                        userProvider.user != null) {
                                      setState(() {
                                        currentUI = 'home';
                                      });
                                      // ignore: avoid_print
                                      print(
                                          '로그인 성공: ${userProvider.user!.email}');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EnterMenu(
                                            currentUser: userProvider.user!,
                                            dataProvider: dataProvider,
                                          ),
                                        ),
                                      );
                                    } else {
                                      //로그인 실패 또는 사용자 정보 없음
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
                                              20.0,
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
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
                                              20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ResetPasswordScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "비밀번호 찾기",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
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

//로그인 성공시 메뉴화면에 진입하는 클래스
class EnterMenu extends StatelessWidget {
  final User currentUser;
  final DataProvider dataProvider;

  const EnterMenu({
    Key? key,
    required this.currentUser,
    required this.dataProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Menu();
  }
}
