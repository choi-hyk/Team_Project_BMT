import 'package:flutter/material.dart';
import 'package:test1/algorithm_code/graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> documentDataList = [];
  late Graph timeGraph;
  late Graph costGraph;

  Future<void> fetchDocumentList() async {
    // Firestore에서 데이터 가져오기
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Lines') // 여기에 컬렉션 이름을 넣어주세요
        .get();

    // 각 문서의 데이터를 List<Map>으로 변환하여 저장
    documentDataList = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    timeGraph = Graph(905);
    costGraph = Graph(905);

    timeGraph.makeGraph(documentDataList, 'time');
    costGraph.makeGraph(documentDataList, 'cost');

    notifyListeners();
  }

  Graph getTimeGraph() {
    return timeGraph;
  }

  Graph getCostGraph() {
    return costGraph;
  }
}
