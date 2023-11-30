import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class BookmarkPage extends StatefulWidget {
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

  // 입력 다이얼로그를 보여주는 메소드
  void showAddDialog(bool isRoute) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isRoute ? '경로 추가' : '역 추가'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (!isRoute) // 역 추가
                  TextField(
                    controller: stationController,
                    decoration: InputDecoration(
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
                    decoration: InputDecoration(
                      labelText: '출발역',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  TextField(
                    controller: station2Controller,
                    decoration: InputDecoration(
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
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('추가'),
              onPressed: isRoute ? addBookmarkRoute : addBookmarkStation,
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
          return Center(child: CircularProgressIndicator());
        }

        var stationWidgets = stationSnapshot.data!.docs.map((document) {
          return ListTile(
            title: Text('${document['station']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                document.reference.delete();
              },
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
              return Center(child: CircularProgressIndicator());
            }

            var routeWidgets = routeSnapshot.data!.docs.map((document) {
              return ListTile(
                title: Text(
                    '${document['station1_ID']}  ->  ${document['station2_ID']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    document.reference.delete();
                  },
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
        title: Text('즐겨찾기'),
        actions: <Widget>[
          TextButton(
            child: Text('역 추가',
                style: TextStyle(color: Colors.white)), // 텍스트 버튼으로 변경
            onPressed: () => showAddDialog(false), // 역 추가 다이얼로그
          ),
          TextButton(
            child: Text('경로 추가',
                style: TextStyle(color: Colors.white)), // 텍스트 버튼으로 변경
            onPressed: () => showAddDialog(true), // 역 추가 다이얼로그
          ),
        ],
      ),
      body: buildBookmarkList(),
    );
  }
}
