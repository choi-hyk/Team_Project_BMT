import 'package:flutter/material.dart';
import 'package:test1/bookmark_widgets/bookmark_page.dart';
import 'package:test1/home_UI.dart';
import 'package:test1/login_widgets/login_ui.dart';
import 'package:test1/main.dart';
import 'package:test1/menu_widgets/lost_and_found.dart';
import 'package:test1/menu_widgets/station_bulletin.dart';
import 'package:test1/menu_widgets/store_page.dart';
import 'search_widgets/stationdata_UI.dart';
import 'settings_widgets/settings_UI.dart';
import 'user_widgets/Account_UI.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:test1/algorithm_code/graph.dart';

//InterFace 클래스
class InterFace extends StatefulWidget {
  final User currentUser;
  final List<Map<String, dynamic>> documentDataList;

  const InterFace({
    super.key,
    required this.currentUser, //유저 정보
    required this.documentDataList, //호선도 정보
  });
  @override
  State<InterFace> createState() => _InterFaceState();
}

class _InterFaceState extends State<InterFace> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "";
  bool nRoom = false;
  bool cStore = false;
  List<String> nName = [];
  List<String> pName = [];
  List<String> nCong = [];
  List<String> pCong = [];
  List<int> line = [];

  final TextEditingController station = TextEditingController();
  //검색되는 역

//Lines컬렉션 의 다큐먼트 호선 리스트를 역별 데이터로 변환
//i : 다큐먼트 리스트 순회 i + 1 : 호선 번호
//j : 각 필드의 배열 번호  Ex) widget.documentDataList[0]['station'][1] : 1호선의 첫번쨰 역 이름
  void searchData(int searchStation) {
    bool found = false;
    name = "";
    nRoom = false;
    cStore = false;
    nCong.clear();
    pCong.clear();
    line.clear();
    nName.clear();
    pName.clear();

    for (int i = 0; i < 9; i++) {
      int leng = widget.documentDataList[i]['station'].length;
      print(leng - 1);

      for (int j = 0; j < leng; j++) {
        if (widget.documentDataList[i]['station'][j] == searchStation) {
          name = widget.documentDataList[i]['station'][j].toString();
          nRoom = widget.documentDataList[i]['nRoom'][j];
          cStore = widget.documentDataList[i]['cStore'][j];
          nCong
              .add(widget.documentDataList[i]['next_congestion'][j].toString());
          pCong
              .add(widget.documentDataList[i]['prev_congestion'][j].toString());
          line.add(i + 1);
          //순환하는 호선인 1호선과 6호선 처리 과정
          //순환하는 호선이면 맨처음 역과 마지막역을 이어줘야함
          if (i == 0 || i == 5) {
            if (j == 0) {
              nName
                  .add(widget.documentDataList[i]['station'][j + 1].toString());
              pName.add(
                  widget.documentDataList[i]['station'][leng - 1].toString());
            } else if (j == leng - 1) {
              nName.add(widget.documentDataList[i]['station'][0].toString());
              pName
                  .add(widget.documentDataList[i]['station'][j - 1].toString());
            } else {
              nName
                  .add(widget.documentDataList[i]['station'][j + 1].toString());
              pName
                  .add(widget.documentDataList[i]['station'][j - 1].toString());
            }
            //순환하지 않는 호선인 경우
          } else {
            if (j == 0) {
              nName
                  .add(widget.documentDataList[i]['station'][j + 1].toString());
              pName.add("종점역");
            } else if (j == leng - 1) {
              nName.add("종점역");
              pName
                  .add(widget.documentDataList[i]['station'][j - 1].toString());
            } else {
              nName
                  .add(widget.documentDataList[i]['station'][j + 1].toString());
              pName
                  .add(widget.documentDataList[i]['station'][j - 1].toString());
            }
          }
          found = true;
          array = 0;
          break;
        }
      }
    }
    if (!found) {
      currentUI = 'home';
      showSnackBar(
        context,
        const Text("존재하지 않는 역입니다."),
      );
    } else {
      currentUI = "stationdata";
    }
  }

//드로어 함수
  void menuDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

//현재 스크롤어블 위젯 표시 컨테이너
  Widget buildContentWidget() {
    switch (currentUI) {
      case "home":
        return const HomeUI();
      case "stationdata":
        return StationData(
          name: name,
          nRoom: nRoom,
          cStore: cStore,
          nCong: nCong,
          pCong: pCong,
          line: line,
          nName: nName,
          pName: pName,
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
                          child: const SizedBox(
                            width: 40.0,
                            height: 43.5,
                            child: Icon(Icons.menu),
                          ),
                        );
                      }),
                      Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: currentUI == 'home'
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context).primaryColor,
                          ),
                          child: IconButton(
                            onPressed: () {
                              currentUI = 'home'; // 입력된 텍스트 지우기
                            },
                            icon: const Icon(Icons.home),
                          )),
                      const SizedBox(
                        width: 6.5,
                      ),
                      SizedBox(
                        width: 240,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: station,
                          onSubmitted: (String value) {
                            int? searchStation = int.tryParse(value);
                            if (searchStation != null) {
                              searchData(searchStation);
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 10,
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: '역을 입력하세요',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                station.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 23.5,
                      ),
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
                initialChildSize: 0.10,
                maxChildSize: 0.99,
                minChildSize: 0.10,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                      controller: scrollController,
                      child: buildContentWidget());
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
