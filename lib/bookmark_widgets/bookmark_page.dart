import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:test1/provider_code/bookmark_provider.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final TextEditingController stationController =
      TextEditingController(); //역 입력
  final TextEditingController station1Controller =
      TextEditingController(); //역1(출발역) 입력
  final TextEditingController station2Controller =
      TextEditingController(); //역2 (도착역) 입력

  //현재 로그인된 사용자의 UID를 가져오는 함수
  String? getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  //입력 다이얼로그를 보여주는 함수
  void showAddDialog(bool isRoute) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isRoute ? '경로 추가' : '역 추가'), //제목
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (!isRoute) //False일 때 역 추가
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
                if (isRoute) //True일 때 경로 추가
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
              onPressed: () async {
                if (isRoute) {
                  //isRpute에 따라 함수 구별
                  await BookmarkProvider.addBookmarkRoute(
                    station1Controller.text,
                    station2Controller.text,
                  );
                } else {
                  await BookmarkProvider.addBookmarkStation(
                    stationController.text,
                  );
                }
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  //즐겨찾기 목록을 보여주는 위젯
  Widget buildBookmarkList() {
    String? userUid = getCurrentUserUid(); //로그인 사용자 확인

    return StreamBuilder<QuerySnapshot>(
      //DB 가져오기
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
              //이 아이콘을 누르면 DB에서 삭제
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
                  //이 아이콘을 누르면 DB에서 삭제
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
            child: Text('역 추가', style: TextStyle(color: Colors.white)),
            onPressed: () => showAddDialog(false), //역 추가 다이얼로그
          ),
          TextButton(
            child: Text('경로 추가', style: TextStyle(color: Colors.white)),
            onPressed: () => showAddDialog(true), //경로 추가 다이얼로그
          ),
        ],
      ),
      body: buildBookmarkList(),
    );
  }
}
