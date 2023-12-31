import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test1/Interface/menu.dart';
import 'package:test1/Provider/data_provider.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/Route/route_result.dart';
import 'package:test1/Station/link_stationdata.dart';
import 'package:test1/main.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({
    super.key,
  });

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  final TextEditingController stationController = TextEditingController();
  final TextEditingController station1Controller = TextEditingController();
  final TextEditingController station2Controller = TextEditingController();

  DataProvider dataProvider = DataProvider();
  UserProvider userProvider = UserProvider();

  //현재 로그인된 사용자의 UID를 가져오는 메소드
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

  //경로 제거 메소드
  void removeRoute(String station1, String station2) async {
    await userProvider.removeBookmarkRoute(station1, station2);
  }

  //역 또는 경로 추가 다이어로그 메소드
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
                if (!isRoute) //False라면 역 추가
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
                if (isRoute) //True라면 경로 추가
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
              child: const Text(
                '취소',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
          ],
        );
      },
    );
  }

  //역 데이터를 가져오는 메소드
  Future<void> returnStationData(String station) async {
    await dataProvider.searchData(int.parse(station));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LinkStationData(
          name: dataProvider.name,
          nRoom: dataProvider.nRoom,
          cStore: dataProvider.cStore,
          isBkMk: dataProvider.isBkmk,
          line: dataProvider.line,
          nName: dataProvider.nName,
          pName: dataProvider.pName,
          nCong: dataProvider.nCong,
          pCong: dataProvider.pCong,
          check: true,
        ),
      ),
    );
  }

  //경로 데이터를 가져오는 메소드
  Future<void> returnRouteData(String statin1, String station2) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteResults(
            startStation: statin1, arrivStation: station2, check: true),
      ),
    );
  }

  //즐겨찾기 목록을 보여주는 위젯
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
        var stationWidgets = stationSnapshot.data!.docs.map((document) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                returnStationData(document['station']);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    '${document['station']} Station',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 20),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      removeStation(document['station']);
                    },
                  ),
                ),
              ),
            ),
          );
        }).toList();
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
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    returnRouteData(
                        document['station1_ID'], document['station2_ID']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            '${document['station1_ID']} Station',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 6.5,
                          ),
                          Icon(
                            FontAwesomeIcons.rightLong,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          const SizedBox(
                            width: 6.5,
                          ),
                          Text(
                            '${document['station2_ID']} Station',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          removeRoute(
                              document['station1_ID'], document['station2_ID']);
                        },
                      ),
                    ),
                  ),
                ),
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        currentUI = 'home';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.pop(context);
              currentUI = "home";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Menu()),
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
                color: Theme.of(context).canvasColor,
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.locationDot,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () => showAddDialog(false), //역 추가 다이얼로그
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
                color: Theme.of(context).canvasColor,
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.route,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () => showAddDialog(true), //경로 추가 다이얼로그
              ),
            ),
            const SizedBox(
              width: 6.5,
            ),
          ],
        ),
        body: buildBookmarkList(),
      ),
    );
  }
}
