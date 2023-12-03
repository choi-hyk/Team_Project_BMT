import 'package:flutter/material.dart';
import 'package:test1/main.dart';
import 'package:test1/Interface/menu.dart';
import 'package:test1/Station/stationdata.dart';

//즐겨찾기 탭에서 StationData로 이동하기 위해 페이지를 새로 빌드하는 클래스
class LinkStationData extends StatefulWidget {
  final List line;
  final String name;
  final bool cStore;
  final bool nRoom;
  final bool isBkMk;
  final List nName;
  final List pName;

  final bool check;

  const LinkStationData({
    super.key,
    required this.line,
    required this.name,
    required this.cStore,
    required this.nRoom,
    required this.nName,
    required this.pName,
    required this.isBkMk,
    required this.check,
  });

  @override
  State<LinkStationData> createState() => _LinkStationDataState();
}

class _LinkStationDataState extends State<LinkStationData> {
  late bool isBkMk = false;

  @override
  void initState() {
    super.initState();
    isBkMk = widget.isBkMk;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        if (widget.check == true) {
          return true; // 이벤트 처리를 여기서 마칩니다.
        } else {
          currentUI = 'home';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Menu()),
          );
          return false; // 이벤트 처리를 여기서 막습니다.
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ), // 뒤로 가기 아이콘
            onPressed: () {
              Navigator.pop(context);
              if (widget.check == true) {
              } else {
                currentUI = 'home';
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Menu()),
                );
              }
            },
          ),
          title: const Text(
            "역 정보",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          actions: const [],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Positioned(
                  bottom: 40,
                  child: StationData(
                    name: widget.name,
                    nRoom: widget.nRoom,
                    cStore: widget.cStore,
                    isBook: isBkMk,
                    line: widget.line,
                    nName: widget.nName,
                    pName: widget.pName,
                    updateIsBookmark: (bool newValue) {
                      setState(() {
                        isBkMk = newValue;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: SizedBox(
                    //광고배너 컨테이너
                    width: double.infinity,
                    height: 55.0,
                    child: Image.asset(
                      'assets/images/광고3.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
