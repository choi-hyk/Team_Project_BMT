import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final TextEditingController stationController = TextEditingController();
  final TextEditingController station1Controller = TextEditingController();
  final TextEditingController station2Controller = TextEditingController();

  // 현재 로그인된 사용자의 UID를 가져오는 메소드
  String? getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // 즐겨찾기 역 추가 메소드
  Future<void> addBookmarkStation() async {
    String? userUid = getCurrentUserUid();
    if (userUid != null && stationController.text.isNotEmpty) {
      CollectionReference bookmarks = FirebaseFirestore.instance
          .collection('Users')
          .doc(userUid)
          .collection('Bookmark_Station');

      await bookmarks.add({
        'station': stationController.text,
      });

      stationController.clear();
      Navigator.of(context).pop();
    }
  }

  // 즐겨찾기 경로 추가 메소드
  Future<void> addBookmarkRoute() async {
    String? userUid = getCurrentUserUid();
    if (userUid != null &&
        station1Controller.text.isNotEmpty &&
        station2Controller.text.isNotEmpty) {
      CollectionReference bookmarks = FirebaseFirestore.instance
          .collection('Users')
          .doc(userUid)
          .collection('Bookmark_Route');

      await bookmarks.add({
        'station1_ID': station1Controller.text,
        'station2_ID': station2Controller.text,
      });

      station1Controller.clear();
      station2Controller.clear();
      Navigator.of(context).pop();
    }
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
              onPressed: isRoute ? addBookmarkRoute : addBookmarkStation,
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

        var stationWidgets = stationSnapshot.data!.docs.map((document) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white // 컨테이너의 모서리를 둥글게 만듭니다.
                  ),
              child: ListTile(
                title: Text(
                  '${document['station']}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    document.reference.delete();
                  },
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
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white // 컨테이너의 모서리를 둥글게 만듭니다.
                      ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          '${document['station1_ID']}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.bold,
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
                          '${document['station2_ID']}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.bold,
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
                        document.reference.delete();
                      },
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
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
