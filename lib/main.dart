// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test1/provider_code/data_provider.dart';
import 'package:test1/login_widgets/login_ui.dart';
//import 'package:flutter/services.dart';
//import 'package:test1/menu_widgets/station_bulletin.dart';
//import 'package:flutter/services.dart';station_bulletin
//import 'package:test1/menu_widgets/.dart';
//import 'package:test1/bookmark_widgets/bookmark_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'package:test1/algorithm_code/graph.dart';
// import 'package:test1/home_UI.dart';

int array = 0; //역 정보 데이터 배열
String currentUI = "login"; //home, stationdata, routesearch, routeresult

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: const Color.fromARGB(255, 112, 48, 48),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

int getMinuteRange(int currentMinute) {
  if (currentMinute >= 0 && currentMinute < 20) {
    return 1;
  } else if (currentMinute >= 20 && currentMinute < 40) {
    return 2;
  } else {
    return 3;
  }
}

//호선 별 색상
Color perlinedata(int currentLine) {
  switch (currentLine) {
    case -1:
      return const Color.fromARGB(255, 225, 213, 213);
    case 1:
      return Colors.green;
    case 2:
      return const Color.fromARGB(255, 14, 67, 111);
    case 3:
      return Colors.brown;
    case 4:
      return Colors.red;
    case 5:
      return const Color.fromARGB(255, 24, 99, 134);
    case 6:
      return const Color.fromARGB(255, 218, 206, 95);
    case 7:
      return const Color.fromARGB(255, 115, 216, 118);
    case 8:
      return const Color.fromARGB(255, 54, 181, 240);
    case 9:
      return Colors.purple;
    default:
      return Colors.white;
  }
}

Color getColorForIndex(int index) {
  switch (index) {
    case 0:
      return const Color.fromARGB(255, 244, 238, 54);
    case 1:
      return const Color.fromARGB(255, 244, 206, 54);
    case 2:
      return const Color.fromARGB(255, 244, 165, 54);
    case 3:
      return const Color.fromARGB(255, 244, 130, 54);
    case 4:
      return Colors.red;
    default:
      return Colors.black;
  }
}

IconData getIconForIndex(int index) {
  switch (index) {
    case 0:
      return FontAwesomeIcons.solidFaceLaughBeam;
    case 1:
      return FontAwesomeIcons.solidFaceSmile;
    case 2:
      return FontAwesomeIcons.solidFaceMeh;
    case 3:
      return FontAwesomeIcons.solidFaceFrown;
    case 4:
      return FontAwesomeIcons.solidFaceTired;
    default:
      return Icons.error;
  }
}

Text getConfText(int index) {
  switch (index) {
    case 0:
      return const Text(
        "여유롭게 지하철을 이용하세요!",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      );
    case 1:
      return const Text(
        "좌석에 앉을수 있을것 같습니다!",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      );
    case 2:
      return const Text(
        "어느정도 사람이 있습니다!",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      );
    case 3:
      return const Text(
        "좌석에는 못 앉을것 같네요...",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      );
    case 4:
      return const Text(
        "출퇴근 시간인가봐요...",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      );
    default:
      return const Text(
        "혼잡도 정보가 제공되지 않습니다.",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); //즐겨찾기, 게시판 db 연동

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

//Main 클래스
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 상태 표시줄 배경색을 투명하게 설정
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //앱 테마
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color.fromARGB(255, 163, 201, 205),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        primaryColorLight: const Color.fromARGB(255, 61, 188, 202),
        primaryColor: const Color.fromARGB(255, 108, 159, 164),
        primaryColorDark: const Color.fromARGB(255, 22, 73, 79),
        cardColor: const Color.fromARGB(255, 233, 255, 243),
      ),
      //InterFace 호출
      home: const LoginUI(),
    );
  }
}
