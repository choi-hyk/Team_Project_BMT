import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkProvider {
  static String? getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  //즐겨찾기 역 추가 함수
  static Future<void> addBookmarkStation(String stationName) async {
    String? userUid = getCurrentUserUid(); //로그인 사용자 확인
    if (userUid != null && stationName.isNotEmpty) {
      //DB에 추가
      CollectionReference bookmarks = FirebaseFirestore.instance
          .collection('Users')
          .doc(userUid)
          .collection('Bookmark_Station');

      await bookmarks.add({
        'station': stationName,
      });
    }
  }

  //즐겨찾기 경로 추가 함수
  static Future<void> addBookmarkRoute(String station1, String station2) async {
    String? userUid = getCurrentUserUid(); //로그인 사용자 확인
    if (userUid != null && station1.isNotEmpty && station2.isNotEmpty) {
      //DB 추가
      CollectionReference bookmarks = FirebaseFirestore.instance
          .collection('Users')
          .doc(userUid)
          .collection('Bookmark_Route');

      await bookmarks.add({
        'station1_ID': station1,
        'station2_ID': station2,
      });
    }
  }
}
