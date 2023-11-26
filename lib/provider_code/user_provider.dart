// Provider를 사용하여 User 객체를 관리하는 예시
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/main.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Authentication 접근을 위한 객체
  User? _user;
  User? get user => _user;

  //Cloud Firestore 접근을 위한 객체
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  UserProvider() {
    // 인증 상태 변경 리스너 설정
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setUser(user);
      }
    });
  }

  void setUser(User user) {
    _user = user;
    notifyListeners(); //상태 변경 알림
  }

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

  //파이어스토어와 연동하여 데이터 가져오기
  Future<dynamic> fetchUserData(String fieldName) async {
    String userId = _user!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (snapshot.exists) {
      return snapshot.data()?[fieldName];
    } else {
      return null; // 문서가 존재하지 않거나 필드가 없는 경우
    }
  }
}
