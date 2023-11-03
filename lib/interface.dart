import 'package:flutter/material.dart';
import 'package:test1/menu_widgets/bulletin_board.dart';
import 'package:test1/menu_widgets/store_page.dart';
import 'search_UI.dart';
import 'star_UI.dart';
import 'settings_widgets/settings_UI.dart';
import 'user_widgets/Account_UI.dart';

//배경화면 노선 이미지 확대 및 버튼 설정 구현 아직 안함
//그리고 노선 이미지 밑에 남는공간 어케할지 생각해야됨

//InterFace 클래스
class InterFace extends StatefulWidget {
  const InterFace({super.key});

  @override
  State<InterFace> createState() => _InterFaceState();
}

//InterFaceState클래스 -> Button을 누르면 해당 UI로 스위치
class _InterFaceState extends State<InterFace> {
  //디폴트 메뉴 search
  String currentUI = "search";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void switchMenu(String selectedMenu) {
    setState(() {
      currentUI = selectedMenu;
    });
  }

//드로어 함수
  void menuDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 77,
            left: 6.5,
            right: 6.5,
            child: InteractiveViewer(
                constrained: true, child: Image.asset("assets/images/노선도.png")),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 33.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Builder(builder: (BuildContext builderContext) {
                      return GestureDetector(
                        onTap: () {
                          Scaffold.of(builderContext).openDrawer();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          width: 40.0,
                          height: 43.5,
                          child: const Icon(Icons.menu),
                        ),
                      );
                    }),
                    UIButton(
                      icon: const Icon(Icons.search),
                      onTap: () => switchMenu("search"),
                    ),
                    UIButton(
                      icon: const Icon(Icons.star),
                      onTap: () => switchMenu("star"),
                    ),
                    UIButton(
                      icon: const Icon(Icons.person),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccountUI()),
                        );
                      },
                    ),
                    UIButton(
                      icon: const Icon(Icons.settings),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsUI()),
                        );
                      },
                    ),
                  ],
                ),
                //DataUI 컨테이너
                SingleChildScrollView(
                  child: DataUI(currentUI: currentUI),
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
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.0),
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
                  child: const Text('스토어')),
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
                      builder: (context) => const BulletinBoardPage(),
                    ),
                  );
                },
                child: const Text('게시판'),
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

//DataUI 클래스 -> 버튼을 누르면 해당 상태로 UI변경
class DataUI extends StatefulWidget {
  final String currentUI;

  const DataUI({super.key, required this.currentUI});

  @override
  State<DataUI> createState() => _DataUIState(currentUI: currentUI);
}

class _DataUIState extends State<DataUI> {
  final String currentUI;

  _DataUIState({required this.currentUI});
  @override
  Widget build(BuildContext context) {
    Widget contentWidget = buildContentWidget(widget.currentUI);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.825,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.99,
        minChildSize: 0.15,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: contentWidget,
          );
        },
      ),
    );
  }

//버튼을 눌렀을때 UI상태를 스위치하는 위젯
  Widget buildContentWidget(String currentUI) {
    switch (currentUI) {
      case "search":
        return const SearchUI();
      case "star":
        return const StarUI();
      default:
        return const SearchUI();
    }
  }
}

//UIButton클래스
class UIButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onTap;

  const UIButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0)),
        width: 70.0,
        height: 43.5,
        child: icon,
      ),
    );
  }
}
