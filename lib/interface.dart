import 'package:flutter/material.dart';
import 'search_UI.dart';
import 'star_UI.dart';
import 'menu_UI.dart';
import 'settings_UI.dart';

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

  void switchMenu(String selectedMenu) {
    setState(() {
      currentUI = selectedMenu;
    });
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
            child: Image.asset("assets/images/노선도.png"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 33.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UIButton(
                      icon: const Icon(Icons.search),
                      onTap: () => switchMenu("search"),
                    ),
                    UIButton(
                      icon: const Icon(Icons.star),
                      onTap: () => switchMenu("star"),
                    ),
                    UIButton(
                      icon: const Icon(Icons.menu),
                      onTap: () => switchMenu("menu"),
                    ),
                    UIButton(
                      icon: const Icon(Icons.settings),
                      onTap: () => switchMenu("settings"),
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
      case "menu":
        return const MenuUI();
      case "settings":
        return const SettingsUI();
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
        width: 90.0,
        height: 43.5,
        child: icon,
      ),
    );
  }
}
