import 'package:flutter/material.dart';
import 'package:test1/algorithm_code/graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/main.dart';
import 'package:test1/provider_code/user_provider.dart';

class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> documentDataList = [];
  late Graph optmGraph;
  late Graph timeGraph;
  late Graph costGraph;

  bool found = false;
  String name = "";
  bool nRoom = false;
  bool cStore = false;
  bool isBkmk = false;
  List<String> nName = [];
  List<String> pName = [];
  List<String> nCong = [];
  List<String> pCong = [];
  List<int> line = [];

  UserProvider userProvider = UserProvider();
  
  get lines => null;

  Future<void> fetchDocumentList() async {
    // Firestore에서 데이터 가져오기
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Lines') // 여기에 컬렉션 이름을 넣어주세요
        .get();

    // 각 문서의 데이터를 List<Map>으로 변환하여 저장
    documentDataList = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    optmGraph = Graph(905);
    timeGraph = Graph(905);
    costGraph = Graph(905);

    optmGraph.makeGraph(documentDataList, 'optimum');
    timeGraph.makeGraph(documentDataList, 'time');
    costGraph.makeGraph(documentDataList, 'cost');

    notifyListeners();
  }

//역정보 검색하는 메소드
//Lines컬렉션 의 다큐먼트 호선 리스트를 역별 데이터로 변환
//i : 다큐먼트 리스트 순회 i + 1 : 호선 번호
//j : 각 필드의 배열 번호  Ex) widget.documentDataList[0]['station'][1] : 1호선의 첫번쨰 역 이름
  Future<void> searchData(int searchStation) async {
    await fetchDocumentList();
    found = false;
    name = "";
    nRoom = false;
    cStore = false;
    isBkmk = false;
    line.clear();
    nName.clear();
    pName.clear();
    for (int i = 0; i < 9; i++) {
      int leng = documentDataList[i]['station'].length;
      for (int j = 0; j < leng; j++) {
        if (documentDataList[i]['station'][j] == searchStation) {
          name = documentDataList[i]['station'][j].toString();
          nRoom = documentDataList[i]['nRoom'][j];
          cStore = documentDataList[i]['cStore'][j];
          line.add(i + 1);
          //순환하는 호선인 1호선과 6호선 처리 과정
          //순환하는 호선이면 맨처음 역과 마지막역을 이어줘야함
          if (i == 0 || i == 5) {
            if (j == 0) {
              nName.add(documentDataList[i]['station'][j + 1].toString());
              pName.add(documentDataList[i]['station'][leng - 1].toString());
            } else if (j == leng - 1) {
              nName.add(documentDataList[i]['station'][0].toString());
              pName.add(documentDataList[i]['station'][j - 1].toString());
            } else {
              nName.add(documentDataList[i]['station'][j + 1].toString());
              pName.add(documentDataList[i]['station'][j - 1].toString());
            }
            //순환하지 않는 호선인 경우
          } else {
            if (j == 0) {
              nName.add(documentDataList[i]['station'][j + 1].toString());
              pName.add("종점역");
            } else if (j == leng - 1) {
              nName.add("종점역");
              pName.add(documentDataList[i]['station'][j - 1].toString());
            } else {
              nName.add(documentDataList[i]['station'][j + 1].toString());
              pName.add(documentDataList[i]['station'][j - 1].toString());
            }
          }
          found = true;
          isBkmk = await userProvider.isStationBookmarked(name);
          array = 0;
          break;
        }
      }
    }
  }

  Graph getOptmGraph() {
    return optmGraph;
  }

  Graph getTimeGraph() {
    return timeGraph;
  }

  Graph getCostGraph() {
    return costGraph;
  }
}
