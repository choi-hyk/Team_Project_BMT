// Provider를 사용하여 User 객체를 관리하는 예시
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test1/menu_widgets/stationdata.dart';
import 'package:test1/provider_code/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:test1/search_widgets/route_result_UI.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  Map<String, dynamic>? _userInfo;

  User? get user => _user;
  Map<String, dynamic>? get userInfo => _userInfo;

  //생성자
  UserProvider() {
    _user = FirebaseAuth.instance.currentUser;
    _fetchUserInfo();
  }

  String uid = FirebaseAuth.instance.currentUser!.uid; //로그인한 사용자 uid

  //사용자 정보 가져오기 함수~
  Future<void> _fetchUserInfo() async {
    if (_user != null) {
      var result = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_user!.uid)
          .get();
      _userInfo = result.data();
      notifyListeners();
    }
    print(_userInfo);
  }

//역 줄겨찾기 여부 확인
  Future<bool> isStationBookmarked(String station) async {
    String? userUid = _user!.uid;
    CollectionReference bookmarks = FirebaseFirestore.instance
        .collection('Users')
        .doc(userUid)
        .collection('Bookmark_Station');

    QuerySnapshot snapshot =
        await bookmarks.where('station', isEqualTo: station).get();
    notifyListeners();

    return snapshot.docs.isNotEmpty; // 즐겨찾기에 해당 역이 이미 존재하는지 여부 반환
  }

//경로 즐겨찾기 여부 확인
  Future<bool> isRouteBookmarked(String station1, String station2) async {
    String? userUid = _user!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userUid)
        .collection('Bookmark_Route')
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String storedStation1 = doc['station1_ID'];
      String storedStation2 = doc['station2_ID'];

      // 두 역의 값이 모두 일치하는 경우 true를 반환합니다.
      if (station1 == storedStation1 && station2 == storedStation2) {
        return true;
      }
    }

    return false;
  }

//즐겨찾기 역 제거 메소드
  Future<void> removeBookmarkStation(String station) async {
    String? userUid = _user!.uid;
    CollectionReference bookmarks = FirebaseFirestore.instance
        .collection('Users')
        .doc(userUid)
        .collection('Bookmark_Station');

    QuerySnapshot querySnapshot =
        await bookmarks.where('station', isEqualTo: station).get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
    notifyListeners();
  }

//즐겨찾기 경로 제거 메소드
  Future<void> removeBookmarkRoute(String station1, String station2) async {
    String? userUid = _user!.uid;
    CollectionReference bookmarks = FirebaseFirestore.instance
        .collection('Users')
        .doc(userUid)
        .collection('Bookmark_Route');

    QuerySnapshot querySnapshot = await bookmarks
        .where('station1_ID', isEqualTo: station1)
        .where('station2_ID', isEqualTo: station2)
        .get();

    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
    notifyListeners();
  }

//역추가 매소드
  Future<void> addBookmarkStation(String station) async {
    bool isBookmarked = await isStationBookmarked(station);

    if (!isBookmarked) {
      String? userUid = _user!.uid;
      CollectionReference bookmarks = FirebaseFirestore.instance
          .collection('Users')
          .doc(userUid)
          .collection('Bookmark_Station');

      await bookmarks.add({
        'station': station,
      });
    }
    notifyListeners();
  }

//경로추가 메소드
  Future<void> addBookmarkRoute(String station1, String station2) async {
    bool isBookmarked = await isRouteBookmarked(station1, station2);

    if (!isBookmarked) {
      String? userUid = _user!.uid;
      CollectionReference bookmarks = FirebaseFirestore.instance
          .collection('Users')
          .doc(userUid)
          .collection('Bookmark_Route');

      await bookmarks.add({
        'station1_ID': station1,
        'station2_ID': station2,
      });
    }
    notifyListeners();
  }

//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  String get name => _userInfo?['name'] ?? 'No Name';
  String get nickname => _userInfo?['nickname'] ?? 'No nickname';
  String get email => _userInfo?['email'] ?? 'No Email';
  String get phone => _userInfo?['phone'] ?? 'No PhoneNumber';
  String get point => _userInfo?['point'].toString() ?? '100';
  String get age => (2024 - _userInfo?['age']).toString();

  //로그인 함수
  Future<String?> handleSignIn(String email, String password) async {
    if (email.isEmpty) {
      return "이메일을 입력하세요.";
    } else if (password.isEmpty) {
      return "비밀번호를 입력하세요.";
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // 성공 시 null 반환
    } on FirebaseAuthException catch (e) {
      return "이메일 또는 비밀번호가 틀렸습니다.";
    }
  }
}
