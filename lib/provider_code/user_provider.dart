import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _userInfo;

  User? get user => _user;
  Map<String, dynamic>? get userInfo => _userInfo;

  //생성자
  UserProvider() {
    _user = FirebaseAuth.instance.currentUser;
    fetchUserInfo();
  }

  //사용자 정보 객체들
  String get name => _userInfo?['name'] ?? 'No Name';
  String get nickname => _userInfo?['nickname'] ?? 'No nickname';
  String get email => _userInfo?['email'] ?? 'No Email';
  String get phone => _userInfo?['phone'] ?? 'No PhoneNumber';
  String get point => _userInfo?['point'].toString() ?? '0';
  String get age => (2024 - _userInfo?['age']).toString();
  String get mainStation => _userInfo?['mainStation'].toString() ?? "101";

  //DB의 mainStaiton값을 변경하는 메소드
  Future<void> updateMainStation(int newStation) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_user!.uid)
          .update({'mainStation': newStation});
    } catch (e) {
      print(e);
    }
  }

  //사용자 정보 가져오기 함수
  Future<void> fetchUserInfo() async {
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

  //로그인 함수
  Future<String?> handleSignIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user;
      await fetchUserInfo(); //사용자 정보 갱신
      notifyListeners();
      return null; //성공 시 null 반환
    } on FirebaseAuthException {
      String errorMessage = "이메일 또는 비밀번호가 틀렸습니다.";
      return errorMessage;
    }
  }

  //로그아웃 함수
  Future<void> handleSignOut() async {
    await _auth.signOut();
    _user = null;
    _userInfo = null;
    notifyListeners();
  }

  //회원 탈퇴 함수
  Future<String?> handleDeleteAccount(String password) async {
    try {
      String? email = _user?.email; //오류 처리
      if (email == null || password.isEmpty) {
        return "이메일 또는 비밀번호가 없습니다.";
      }

      AuthCredential credential = //사용자 인증
          EmailAuthProvider.credential(email: email, password: password);
      await _user!.reauthenticateWithCredential(credential);

      await FirebaseFirestore.instance //Firestore에서 사용자 데이터 삭제
          .collection('Users')
          .doc(_user!.uid)
          .delete();

      await _user!.delete(); //Firebase Authentication에서 사용자 삭제

      _user = null; //사용자 정보 초기화
      _userInfo = null;
      notifyListeners();

      return null; //성공 시 null 반환
    } on FirebaseAuthException catch (e) {
      //오류 처리
      return e.message;
    }
  }

  //작성한 게시글을 불러오는 함수
  Future<List<Map<String, dynamic>>> getWrittenPosts() async {
    try {
      String? userUid = _user!.uid;
      List<Map<String, dynamic>> writtenPosts = [];

      // Fetch posts from Bulletin_Board
      QuerySnapshot bulletinBoardSnapshot = await FirebaseFirestore.instance
          .collection('Bulletin_Board')
          .where('User_ID', isEqualTo: userUid)
          .get();

      for (QueryDocumentSnapshot doc in bulletinBoardSnapshot.docs) {
        writtenPosts.add(doc.data() as Map<String, dynamic>);
      }

      // Fetch posts from Inquiry
      QuerySnapshot inquirySnapshot = await FirebaseFirestore.instance
          .collection('Inquiry')
          .where('User_ID', isEqualTo: userUid)
          .get();

      for (QueryDocumentSnapshot doc in inquirySnapshot.docs) {
        writtenPosts.add(doc.data() as Map<String, dynamic>);
      }

      return writtenPosts;
    } catch (e) {
      print('Error fetching written posts: $e');
      rethrow;
    }
  }

  //포인트를 더하는 함수
  Future<void> addPointsToUser() async {
    try {
      String? userUid = _user!.uid;
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      DocumentReference userDocRef = users.doc(userUid);

      // 해당 사용자 문서 가져오기
      DocumentSnapshot userSnapshot = await userDocRef.get();

      // 사용자 문서가 존재하면
      if (userSnapshot.exists) {
        // 현재 포인트 가져오기
        int currentPoints =
            (userSnapshot.data() as Map<String, dynamic>?)?['point'] ?? 0;

        // 포인트 필드에 100 추가
        int updatedPoints = currentPoints + 100;

        // 업데이트된 포인트로 업데이트
        await userDocRef.update({'point': updatedPoints});
      }
    } catch (e) {
      print('Error adding points to user: $e');
    }
  }

  //즐겨찾기 관련 메소드ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

  //역 즐겨찾기 여부를 확인하는 메소드
  Future<bool> isStationBookmarked(String station) async {
    String? userUid = _user!.uid;
    CollectionReference bookmarks = FirebaseFirestore.instance
        .collection('Users')
        .doc(userUid)
        .collection('Bookmark_Station');

    QuerySnapshot snapshot =
        await bookmarks.where('station', isEqualTo: station).get();
    notifyListeners();

    return snapshot.docs.isNotEmpty; //즐겨찾기에 해당 역이 이미 존재하는지 여부 반환
  }

  //경로 즐겨찾기 여부를 확인하는 메소드
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

      //두 역의 값이 모두 일치하는 경우 true를 반환합니다.
      if (station1 == storedStation1 && station2 == storedStation2) {
        return true;
      }
    }
    return false;
  }

  //즐겨찾기 DB에 역을 추가하는 매소드
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

  //즐겨찾기 DB에서 역을 제거하는 메소드
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

  //즐겨찾기 DB에 경로를 추가하는 메소드
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

  //즐겨찾기 DB에서 경로를 제거하는 메소드
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

  //역 또는 경로의 즐겨찾기 데이터를 가져오는 메소드
  Future<List<Map<String, dynamic>>> getBookmarkList() async {
    String? userUid = _user!.uid;
    List<Map<String, dynamic>> bookmarkList = [];
    //역 즐겨찾기 가져오기
    QuerySnapshot stationSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userUid)
        .collection('Bookmark_Station')
        .get();

    for (QueryDocumentSnapshot doc in stationSnapshot.docs) {
      bookmarkList.add({
        'type': 'station',
        'data': doc['station'],
      });
    }

    //경로 즐겨찾기 가져오기
    QuerySnapshot routeSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userUid)
        .collection('Bookmark_Route')
        .get();

    for (QueryDocumentSnapshot doc in routeSnapshot.docs) {
      bookmarkList.add({
        'type': 'route',
        'data': {
          'station1_ID': doc['station1_ID'],
          'station2_ID': doc['station2_ID'],
        },
      });
    }

    return bookmarkList;
  }
}
