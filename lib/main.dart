import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:test1/Provider/data_provider.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/Interface/startpage.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//전역 변수
int current_trans = 0;
//Station데이터 값 배열 순서
//StationData에서 검색한 역이 환승 가능한경우 호선 순서상 첫번쨰 호선 array = 0, 두번째 호선 array = 1

String currentUI = "login";
//현재 menu화면 상태
//login, home, stationdata

//전역 메소드

//스낵바 구현 함수
void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: const Color.fromARGB(255, 112, 48, 48),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

//분단위 시간을 1, 2, 3 으로 환산
//혼잡도 정보 저장하고 불러올때 사용
//0 ~ 19분 -> 1, 20 ~ 39 -> 2, 40 ~ 59 -> 3
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

//혼잡도 아이콘 제공할때 사용하는 메소드
//매개변수에 혼잡도 값 들어감 -> 혼잡도 : 0 ~ 4
//아이콘 색상 메소드
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

//아이콘 모양 메소드
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

//혼잡도 안내 텍스트 메소드
Text getConfText(int index) {
  switch (index) {
    case 0:
      return const Text(
        "여유롭게 지하철을 이용하세요!",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );
    case 1:
      return const Text(
        "좌석에 앉을수 있을것 같습니다!",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );
    case 2:
      return const Text(
        "어느정도 사람이 있습니다!",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );
    case 3:
      return const Text(
        "좌석에는 못 앉을것 같네요...",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );
    case 4:
      return const Text(
        "출퇴근 시간인가봐요...",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );
    default:
      return const Text(
        "혼잡도 정보가 제공되지 않습니다.",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );
  }
}

//메인 메소드 -> 메인 테마 색 설정 및 앱 구동
//StartPage로 이동
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Flutter 엔진과 위젯 바인딩 초기화

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color.fromARGB(255, 175, 222, 227),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        primaryColorLight: const Color.fromARGB(255, 117, 154, 167),
        primaryColor: const Color.fromARGB(255, 108, 159, 164),
        primaryColorDark: const Color.fromARGB(255, 22, 73, 79),
        cardColor: const Color.fromARGB(255, 233, 255, 243),
      ),
      home: const StartPage(),
    );
  }
}
