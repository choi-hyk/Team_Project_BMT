import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 추가된 부분
import 'package:test1/algorithm_code/graph.dart';

class DataProvider with ChangeNotifier {
  Graph? costGraph; // 비용 그래프
  Graph? timeGraph; // 시간 그래프
  List<Map<String, dynamic>> documentDataList = [];

  void initializeGraphs(List<Map<String, dynamic>> documentDataList) {
    costGraph = Graph(143);
    timeGraph = Graph(143);
    costGraph!.makeGraph(documentDataList, 'cost');
    timeGraph!.makeGraph(documentDataList, 'time');
    notifyListeners();
  }

  Future<void> fetchDocumentList() async {
    // Firestore에서 데이터 가져오기
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Lines') // 여기에 컬렉션 이름을 넣어주세요
        .get();

    // 각 문서의 데이터를 List<Map>으로 변환하여 저장
    documentDataList = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    notifyListeners();
  }
}
