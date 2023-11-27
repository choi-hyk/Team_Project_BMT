// Provider를 사용하여 User 객체를 관리하는 예시
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
