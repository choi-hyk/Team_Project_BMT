import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/Board/lost_board_list.dart';
import 'package:test1/Board/station_board_list.dart';
import 'package:test1/Bookmark/bookmark.dart';
import 'package:test1/Interface/Home.dart';
import 'package:test1/Interface/settings.dart';
import 'package:test1/Interface/startpage.dart';
import 'package:test1/Provider/data_provider.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/Station/stationdata.dart';
import 'package:test1/Station/stationmap.dart';
import 'package:test1/Store/store.dart';
import 'package:test1/main.dart';

//Menu 클래스
//메인 화면 : 역검색, 노선도, 사용자 메뉴
//드로어 : 설정, 스토어, 즐겨찾기, 역별 게시판, 분실물 게시판, 로그아웃
class Menu extends StatefulWidget {
  const Menu({
    super.key,
  });
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider userProvider = UserProvider();
  DataProvider dataProvider = DataProvider();
  String? tappedStationKey;
  final TextEditingController station = TextEditingController();

  //노선도 맵핑 -> 노선도 상 터치된 역 가져오는 함수 역 터치할 경우 StationData에 해당 역 빌드
  void onTapStation(String stationKey) {
    setState(() {
      tappedStationKey = stationKey;
    });
    waitData(int.parse(stationKey));
  }

  //드로어 함수 -> 드로어 아이콘 누를경우 좌측에서 드로어 나옴
  void menuDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  //역 검색 시에역 정보 불러오는 함수
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

  //현재 메인메뉴 표시 컨테이너
  //역 검색 할 경우 currentUI -> stationdata
  //기본 메뉴 및 홈 아이콘 터치할 경우 currentUI -> home
  Widget buildContentWidget() {
    switch (currentUI) {
      case "home":
        return Home(mainStation: mainStation);
      case "stationdata":
        return StationData(
          name: dataProvider.name,
          nRoom: dataProvider.nRoom,
          cStore: dataProvider.cStore,
          isBook: dataProvider.isBkmk,
          line: dataProvider.line,
          nName: dataProvider.nName,
          pName: dataProvider.pName,
          nCong: dataProvider.nCong,
          pCong: dataProvider.pCong,
          updateIsBookmark: (bool newValue) {
            setState(() {
              dataProvider.isBkmk = newValue; // isBkMk 값을 업데이트합니다.
            });
          },
        );
      default:
        return Home(
          mainStation: mainStation,
        );
    }
  }

  //뒤로가기 터치할 경우에 로그아웃 확인 다이얼로그 보여주는 메소드
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
  //init함수
  void initState() {
    super.initState();
    updateUserProviderData();
  }

  //사용자 정보 업데이트하는 메소드 -> 로그인 하면서 사용자 정보 패치
  Future<void> updateUserProviderData() async {
    await userProvider.fetchUserInfo();
    setState(() {
      point = userProvider.point;
      mainStation = userProvider.mainStation;
      currentUI = 'home';
    });
  }

  String mainStation = "";
  String point = "";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
                                    current_trans = 0;
                                    currentUI = 'home';
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Menu()),
                                    );
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
                                      current_trans = 0;
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
              child: SizedBox(
                //광고배너 컨테이너
                width: double.infinity,
                height: 55.0,
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
                currentAccountPicture: Image.asset(
                  "assets/images/Fast1.png",
                  fit: BoxFit.contain,
                  width: 300,
                  height: 300,
                ),
                accountName: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        "USER  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        userProvider.nickname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).primaryColorDark),
                      ),
                    ],
                  ),
                ),
                accountEmail: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        "E-Mail ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        userProvider.email,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).primaryColorDark),
                      ),
                      const SizedBox(
                        width: 40.0,
                      ),
                      Container(
                        width: 60,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${point}p",
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                            builder: (context) => const Settings()),
                      );
                    },
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).primaryColorDark,
                      size: 30,
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
                      Text(
                        '스토어',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark),
                      ),
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
                      MaterialPageRoute(builder: (context) => const Bookmark()),
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
                      Text(
                        '즐겨찾기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
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
                        builder: (context) => const StationBoardList(),
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
                      Text(
                        '역별 게시판',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark),
                      ),
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
                          builder: (context) => const LostBoardList()),
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
                      Text(
                        '분실물 게시판',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
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
                      (Route<dynamic> route) => false,
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
                      Text(
                        '로그아웃',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
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
