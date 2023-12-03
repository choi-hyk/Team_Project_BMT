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
  //기본 역을 변경하는 위젯
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("기본역 변경하기"),
        backgroundColor: const Color.fromARGB(255, 108, 159, 164),
      ),
      backgroundColor: const Color.fromARGB(255, 108, 159, 164),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
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
                    filled: true,
                    fillColor: Colors.white,
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
