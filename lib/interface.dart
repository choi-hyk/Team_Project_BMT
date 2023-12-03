import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/bookmark_widgets/bookmark_page.dart';
import 'package:test1/home_UI.dart';
import 'package:test1/login_widgets/login_ui.dart';
import 'package:test1/main.dart';
import 'package:test1/menu_widgets/lost_and_found.dart';
import 'package:test1/menu_widgets/station_bulletin.dart';
import 'package:test1/menu_widgets/store_page.dart';
import 'package:test1/provider_code/data_provider.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'package:test1/startpage.dart';
import 'search_widgets/stationdata_UI.dart';
import 'settings_widgets/settings_UI.dart';
import 'user_widgets/Account_UI.dart';
import 'StationMap.dart';
//import 'package:test1/algorithm_code/graph.dart';

//InterFace 클래스
class InterFace extends StatefulWidget {
  const InterFace({
    super.key,
  });
  @override
  State<InterFace> createState() => _InterFaceState();
}

class _InterFaceState extends State<InterFace> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider userProvider = UserProvider();
  DataProvider dataProvider = DataProvider();
  String? tappedStationKey;
  final TextEditingController station = TextEditingController();
  //검색되는 역

  void onTapStation(String stationKey) {
    setState(() {
      tappedStationKey = stationKey;
    });
    waitData(int.parse(stationKey));
  }

//드로어 함수
  void menuDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> waitData(int searchStation) async {
    await dataProvider.searchData(searchStation);
    if (!dataProvider.found) {
      showSnackBar(context, const Text("존재하지 않는 역입니다"));
      setState(() {
        currentUI = "home";
      });
    } else {
      setState(() {
        currentUI = "stationdata";
      });
    }
  }

//현재 스크롤어블 위젯 표시 컨테이너
  Widget buildContentWidget() {
    switch (currentUI) {
      case "home":
        return const HomeUI();

      case "stationdata":
        return StationData(
          name: dataProvider.name,
          nRoom: dataProvider.nRoom,
          cStore: dataProvider.cStore,
          isBkMk: dataProvider.isBkmk,
          nCong: dataProvider.nCong,
          pCong: dataProvider.pCong,
          line: dataProvider.line,
          nName: dataProvider.nName,
          pName: dataProvider.pName,
          updateIsBookmark: (bool newValue) {
            setState(() {
              dataProvider.isBkmk = newValue; // isBkMk 값을 업데이트합니다.
            });
          },
        );
      default:
        return const HomeUI();
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              '로그아웃',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              '로그아웃 하시겟습니까?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  '취소',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const StartPage()),
                  );
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    updateUserProviderData();
  }

  // 유저 포인트 값을 받기 위함
  Future<void> updateUserProviderData() async {
    await userProvider.fetchUserInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); //사용자 정보 사용을 위해
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
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
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                width: 500,
                height: 560,
                child: StationMap(
                  onTapStation: onTapStation,
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
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 19,
                        ),
                        Row(
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
                                  setState(() {
                                    currentUI = 'home';
                                  });
                                },
                                icon: const Icon(Icons.home),
                              ),
                            ),
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
                                    setState(() {
                                      waitData(searchStation);
                                    });
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 56,
              left: 0,
              right: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.841),
                child: DraggableScrollableSheet(
                  initialChildSize: 0.21,
                  maxChildSize: .99,
                  minChildSize: 0.21,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
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
                height: 55.0,
                color: Colors.green,
                child: Image.asset(
                  'assets/images/광고1.png',
                  fit: BoxFit.fill,
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
                accountName: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountUI()),
                    );
                  },
                  child: Text(
                    userProvider.nickname,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  child: Row(
                    children: [
                      Text(userProvider.email),
                      const SizedBox(
                        width: 70.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C61FF),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${userProvider.point}p",
                        ),
                      ),
                    ],
                  ),
                ),
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
                      MaterialPageRoute(
                          builder: (context) => const StorePage()),
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
                    currentUI = 'home';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookmarkPage()),
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
                  onTap: () async {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    await userProvider.handleSignOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartPage(),
                      ),
                      (Route<dynamic> route) => false, //네비게이터 초기화
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
      ),
    );
  }
}
