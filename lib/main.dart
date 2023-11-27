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
          backgroundColor: const Color.fromARGB(255, 123, 97, 255),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        primaryColorLight: const Color.fromARGB(255, 123, 97, 255),
        primaryColor: const Color.fromARGB(255, 123, 97, 255), //앱바 색상
        primaryColorDark: const Color.fromARGB(255, 123, 97, 255),
        cardColor: const Color.fromARGB(255, 233, 255, 243),
      ),
      //InterFace 호출
      home: const LoginUI(),
    );
  }
}
