import 'package:flutter/material.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LogInState();
}

class _LogInState extends State<LoginUI> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Log in'),
      //   elevation: 0.0,
      //   backgroundColor: Colors.redAccent,
      //   centerTitle: true,
      //   leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
      //   actions: <Widget>[
      //     IconButton(icon: const Icon(Icons.search), onPressed: () {})
      //   ],
      // ),
      // email, password 입력하는 부분을 제외한 화면을 탭하면, 키보드 사라지게 GestureDetector 사용
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              Form(
                child: Theme(
                  data: ThemeData(
                      primaryColor: Colors.grey,
                      inputDecorationTheme: const InputDecorationTheme(
                          labelStyle:
                              TextStyle(color: Colors.teal, fontSize: 15.0))),
                  child: Container(
                      padding: const EdgeInsets.all(40.0),
                      child: Builder(builder: (context) {
                        return Column(
                          children: [
                            TextField(
                              controller: controller,
                              autofocus: true,
                              decoration: const InputDecoration(
                                  labelText: 'Enter email'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            TextField(
                              controller: controller2,
                              decoration: const InputDecoration(
                                  labelText: 'Enter password'),
                              keyboardType: TextInputType.text,
                              obscureText: true, // 비밀번호 안보이도록 하는 것
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            ButtonTheme(
                                minWidth: 100.0,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller.text ==
                                            'thswnsrb467@naver.com' &&
                                        controller2.text == '1234') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const NextPage()));
                                    } else if (controller.text ==
                                            'thswnsrb467@naver.com' &&
                                        controller2.text != '1234') {
                                      showSnackBar(context,
                                          const Text('Wrong password'));
                                    } else if (controller.text !=
                                            'thswnsrb467@naver.com' &&
                                        controller2.text == '1234') {
                                      showSnackBar(
                                          context, const Text('Wrong email'));
                                    } else {
                                      showSnackBar(context,
                                          const Text('Check your info again'));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 35.0,
                                  ),
                                ))
                          ],
                        );
                      })),
                ),
              )
            ],
          ),
        ),
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
    return Container();
  }
}
