import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test1/Provider/user_provider.dart';

class Customizing extends StatefulWidget {
  const Customizing({super.key});

  @override
  State<Customizing> createState() => _CustomizingState();
}

class _CustomizingState extends State<Customizing> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("위젯 커스터마이징"),
        backgroundColor: const Color.fromARGB(255, 108, 159, 164),
      ),
      backgroundColor: const Color.fromARGB(255, 108, 159, 164),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              // Container를 추가하여 TextField의 배경색을 흰색으로 설정합니다.
              child: Container(
                color: Colors.white, // Container의 배경색을 흰색으로 설정
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    int? stationNumber = int.tryParse(value);
                    if (stationNumber != null) {
                      userProvider.updateMainStation(stationNumber);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "홈 화면에 표시할 게시판의 역",
                    filled: true, // 필드 배경색을 채우기 위해 true로 설정
                    fillColor: Colors.white, // 필드 배경색을 흰색으로 설정
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("저장"),
            ),
          ],
        ),
      ),
    );
  }
}
