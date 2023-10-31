import 'package:flutter/material.dart';
import 'package:test1/interface.dart';

void main() {
  runApp(const MyApp());
}

//Main 클래스
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //앱 테마
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        primaryColor: const Color.fromARGB(255, 246, 243, 243),
        cardColor: const Color.fromARGB(255, 224, 224, 224),
      ),
      //InterFace 호출
      home: const InterFace(),
    );
  }
}
