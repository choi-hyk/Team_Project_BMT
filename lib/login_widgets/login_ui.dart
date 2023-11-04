import 'package:flutter/material.dart';
import 'package:test1/interface.dart';

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
                                height: 30.0,
                              ),
                              ButtonTheme(
                                minWidth: 100.0,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller.text ==
                                            '8167chhk@naver.com' &&
                                        controller2.text == 'chhk8167') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const InterFace(),
                                        ),
                                      );
                                    } else if (controller.text ==
                                            'thswnsrb467@naver.com' &&
                                        controller2.text != '1234') {
                                      showSnackBar(context,
                                          const Text('Wrong password'));
                                    } else if (controller.text !=
                                            'thswnsrb467@naver.com' &&
                                        controller2.text == '1234') {
                                      showSnackBar(
                                        context,
                                        const Text('Wrong email'),
                                      );
                                    } else {
                                      showSnackBar(
                                        context,
                                        const Text('Check your info again'),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColorDark),
                                  child: const Icon(
                                    Icons.login_sharp,
                                    color: Colors.white,
                                    size: 30.0,
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
    return Container();
  }
}
