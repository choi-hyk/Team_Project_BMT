import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test1/interface.dart';
import 'package:test1/main.dart';
import 'package:test1/menu_widgets/stationdata.dart';
import 'package:test1/provider_code/data_provider.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'package:test1/search_widgets/route_result_UI.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({
    super.key,
  });

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final TextEditingController stationController = TextEditingController();
  final TextEditingController station1Controller = TextEditingController();
  final TextEditingController station2Controller = TextEditingController();

  DataProvider dataProvider = DataProvider();
  UserProvider userProvider = UserProvider();

  // 현재 로그인된 사용자의 UID를 가져오는 메소드
  String? getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  //즐겨찾기 역 추가 메소드
  Future<void> addStation(String station) async {
    await dataProvider.searchData(int.parse(station));
    if (!dataProvider.found) {
      showSnackBar(context, const Text("존재하지 않는 역입니다"));
    } else {
      userProvider.addBookmarkStation(station);
      if (await userProvider.isStationBookmarked(station)) {
        showSnackBar(context, const Text("이미 즐겨찾기에 추가된 역입니다"));
      }
    }
    stationController.clear();
    Navigator.of(context).pop();
  }

//경로 추가 메소드
  Future<void> addRoute(String station1, String station2) async {
    await dataProvider.searchData(int.parse(station1));
    if (!dataProvider.found) {
      showSnackBar(context, const Text("출발역이 존재하지 않는 역입니다"));
    } else {
      if (await userProvider.isRouteBookmarked(station1, station2)) {
        showSnackBar(context, const Text("이미 존재하는 경로입니다"));
      }
      {
        await dataProvider.searchData(int.parse(station2));
        if (!dataProvider.found) {
          showSnackBar(context, const Text("도착역이 존재하지 않는 역입니다"));
        } else {
          userProvider.addBookmarkRoute(station1, station2);
        }
      }
    }
    station1Controller.clear();
    station2Controller.clear();
    Navigator.of(context).pop();
  }

//역 제거 메소드
  void removeStation(String station) async {
    await userProvider.removeBookmarkStation(station);
  }

  void removeRoute(String station1, String station2) async {
    await userProvider.removeBookmarkRoute(station1, station2);
  }

  void showAddDialog(bool isRoute) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isRoute ? '경로 추가' : '역 추가',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (!isRoute) // 역 추가
                  TextField(
                    controller: stationController,
                    decoration: const InputDecoration(
                      labelText: '역',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                if (isRoute) // 경로 추가
                  ...[
                  TextField(
                    controller: station1Controller,
                    decoration: const InputDecoration(
                      labelText: '출발역',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  TextField(
                    controller: station2Controller,
                    decoration: const InputDecoration(
                      labelText: '도착역',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ]
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (isRoute) {
                  addRoute(station1Controller.text, station2Controller.text);
                } else {
                  addStation(stationController.text);
                }
              },
              child: const Text(
                '추가',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              child: const Text(
                '취소',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> returnStationData(String station) async {
    await dataProvider.searchData(int.parse(station));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationDataPage(
          name: dataProvider.name,
          nRoom: dataProvider.nRoom,
          cStore: dataProvider.cStore,
          isBkMk: dataProvider.isBkmk,
          nCong: dataProvider.nCong,
          pCong: dataProvider.pCong,
          line: dataProvider.line,
          nName: dataProvider.nName,
          pName: dataProvider.pName,
        ),
      ),
    );
  }

  Future<void> returnRouteData(String statin1, String station2) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RouteResults(startStation: statin1, arrivStation: station2),
      ),
    );
  }

  // 즐겨찾기 목록을 보여주는 위젯
  Widget buildBookmarkList() {
    String? userUid = getCurrentUserUid();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userUid)
          .collection('Bookmark_Station')
          .snapshots(),
      builder: (context, stationSnapshot) {
        if (stationSnapshot.hasError) {
          return Text('오류가 발생했습니다: ${stationSnapshot.error}');
        }

        if (stationSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var stationWidgets = stationSnapshot.data!.docs
            .map((document) => Column(
                  children: [
                    ListTile(
                      title: Text('${document['station']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          document.reference.delete(); //DB에서 삭제
                        },
                      ),
                    ),
                    Divider(),
                  ],
                ))
            .toList();

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userUid)
              .collection('Bookmark_Route')
              .snapshots(),
          builder: (context, routeSnapshot) {
            if (routeSnapshot.hasError) {
              return Text('오류가 발생했습니다: ${routeSnapshot.error}');
            }

            if (routeSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var routeWidgets = routeSnapshot.data!.docs.map((document) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                        '${document['station1_ID']}  ->  ${document['station2_ID']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        document.reference.delete(); //DB에서 삭제
                      },
                    ),
                  ),
                  Divider(), // 각 아이템 아래에 구분선 추가
                ],
              );
            }).toList();

            return ListView(
              children: [
                ...stationWidgets,
                ...routeWidgets,
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            currentUI = "home";
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InterFace()), // 다음으로 이동할 페이지
            );
          },
        ),
        title: const Text(
          '즐겨찾기',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: <Widget>[
          Container(
            width: 50,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).canvasColor),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.locationDot, // 변경할 아이콘
                color: Theme.of(context).primaryColorDark, // 아이콘 색상
              ),
              onPressed: () => showAddDialog(false), // 역 추가 다이얼로그
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Container(
            width: 50,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).canvasColor),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.route, // 변경할 아이콘
                color: Theme.of(context).primaryColorDark, // 아이콘 색상
              ),
              onPressed: () => showAddDialog(true), // 역 추가 다이얼로그
            ),
          ),
          const SizedBox(
            width: 6.5,
          ),
        ],
      ),
      body: buildBookmarkList(),
    );
  }
}
