import 'package:flutter/material.dart';
import 'package:test1/bookmark_widgets/bookmark_page.dart';
import 'package:test1/home_UI.dart';
import 'package:test1/login_widgets/login_ui.dart';
import 'package:test1/menu_widgets/lost_and_found.dart';
import 'package:test1/menu_widgets/station_bulletin.dart';
import 'package:test1/menu_widgets/store_page.dart';
import 'search_widgets/stationdata_UI.dart';
import 'settings_widgets/settings_UI.dart';
import 'user_widgets/Account_UI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

//배경화면 노선 이미지 확대 및 버튼 설정 구현 아직 안함
//그리고 노선 이미지 밑에 남는공간 어케할지 생각해야됨

//InterFace 클래스
class InterFace extends StatefulWidget {
  const InterFace({super.key});

  @override
  State<InterFace> createState() => _InterFaceState();
}

class _InterFaceState extends State<InterFace> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _stationId = ""; //StationData에 들어가는 매개 변수
  String name = ""; //name에 들어가는 매개 변수
  String next = ""; //next에 들어가는 매개 변수
  String prev = ""; //prev에 들어가는 매개 변수
  bool cStore = false;
  bool nursingRoom = false;
  bool toilet = false;

  String currentUI = "home"; //현재 드래그 UI
  final TextEditingController station = TextEditingController(); //검색되는 역

//검색바에 입력되는 역번호 가져오기
  void getData(String searchStation) async {
    try {
      final DocumentSnapshot stationData =
          await firestore.collection('Stations').doc(searchStation).get();

      if (stationData.exists) {
        // 일치하는 ID를 가진 문서를 찾았습니다.
        String documentId = stationData.id;

        print('일치하는 문서 ID: $documentId');
        // 이제 문서 ID를 추가 작업에 사용할 수 있습니다.
        setState(() {
          currentUI = 'stationdata';
          _stationId = documentId;
          name = stationData.get('name');
          next = stationData.get('next');
          prev = stationData.get('previous'); // 검색된 역번호의 ID를 저장
          cStore = stationData.get('cStore');
          nursingRoom = stationData.get('nursingRoom');
          toilet = stationData.get('toilet');
        });
      } else {
        print('$searchStation ID에 해당하는 문서를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('검색 중 오류 발생: $e');
    }
  }

//드로어 함수
  void menuDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

//현재 스크롤어블 위젯 표시 컨테이너
  Widget buildContentWidget(String currentUI) {
    switch (currentUI) {
      case "home":
        return const HomeUI();
      case "stationdata":
        return StationData(
          stationId: _stationId,
          name: name,
          next: next,
          prev: prev,
          toilet: toilet,
          cStore: cStore,
          nursingRoom: nursingRoom,
        );
      default:
        return const HomeUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 95,
            left: 6.5,
            right: 6.5,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              width: 500,
              height: 560,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.5,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    child: Image.asset("assets/images/노선도.png",
                        width: 500, height: 560, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                width: double.infinity,
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Builder(builder: (BuildContext builderContext) {
                        return GestureDetector(
                          onTap: () {
                            Scaffold.of(builderContext).openDrawer();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            width: 40.0,
                            height: 43.5,
                            child: const Icon(Icons.menu),
                          ),
                        );
                      }),
                      SizedBox(
                        width: 285,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: station,
                          onSubmitted: (String searchStation) {
                            getData(searchStation);
                          },
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: '역을 입력하세요',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          station.clear(); // 입력된 텍스트 지우기
                        },
                        icon: const Icon(Icons.cancel),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 59,
            left: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.825),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.99,
                minChildSize: 0.10,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                      controller: scrollController,
                      child: buildContentWidget(currentUI));
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              //광고배너 컨테이너
              width: double.infinity,
              height: 60.0,
              color: Colors.green,
              child: const Center(
                child: Text("광고 배너"),
              ),
            ),
          ),
        ],
      ),
//__________드로어____________________________________________________________________
//사용자 프로필, 설정, 스토어, 게시판 이동가능
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountUI(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/사용자 프로필.png"),
                  backgroundColor: Colors.white,
                ),
              ),
              accountName: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountUI()),
                  );
                },
                child: const Text("CHOI_HYUK"),
              ),
              accountEmail: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountUI(),
                      ),
                    );
                  },
                  child: const Text("8176chhk@naver.com")),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
              ),
              otherAccountsPictures: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsUI()),
                    );
                  },
                  child: const Icon(
                    Icons.settings,
                  ),
                ),
              ],
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StorePage()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.store,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('스토어'),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StationBulletin(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.comment,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('역별 게시판'),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LostAndFound()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.comment,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('분실물 게시판'),
                  ],
                ),
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookMark()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('즐겨찾기'),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginUI(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('로그아웃'),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
