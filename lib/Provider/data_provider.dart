import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/Algorithm/graph.dart';
import 'package:test1/main.dart';

//데이터 프로바이더 함수 -> 데이터 프로바이더 객체 선언후 함수 사용가능
class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> documentDataList = [];

  late Graph optmGraph; //최적 가중치 그래프
  late Graph timeGraph; //시간 가중치 그래프
  late Graph costGraph; //비용 가중치 그래프

  //그래프 리턴하는 메소드
  Graph getOptmGraph() {
    return optmGraph;
  }

  Graph getTimeGraph() {
    return timeGraph;
  }

  Graph getCostGraph() {
    return costGraph;
  }

  //StationData를 빌드하기위해 SearchStation메소드에서 변수들을 저장하는 변수들
  bool found = false;
  String name = "";
  bool nRoom = false;
  bool cStore = false;
  bool isBkmk = false;
  List<String> nName = [];
  List<String> pName = [];
  int nCong = 0;
  int pCong = 0;
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
    nCong = 0;
    pCong = 0;
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
          if (nName[0] != "종점역") {
            nCong = await getCongestionData(
              int.parse(name),
              int.parse(nName[0]),
            );
          } else {
            nCong = -1;
          }
          if (pName[0] != "종점역") {
            pCong =
                await getCongestionData(int.parse(name), int.parse(pName[0]));
          } else {
            pCong = -1;
          }

          isBkmk = await userProvider.isStationBookmarked(name);
          current_trans = 0;
          break;
        }
      }
    }
  }

  Future<void> searchRoute(int searchStation) async {
    await fetchDocumentList();
    name = "";
    isBkmk = false;
    line.clear();
    nName.clear();
    pName.clear();
    for (int i = 0; i < 9; i++) {
      int leng = documentDataList[i]['station'].length;
      for (int j = 0; j < leng; j++) {
        if (documentDataList[i]['station'][j] == searchStation) {
          name = documentDataList[i]['station'][j].toString();
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
          current_trans = 0;
          break;
        }
      }
    }
  }

  Future<int> getCongestionData(int current, int link) async {
    int currentHour = DateTime.now().hour;
    int currentMinute = DateTime.now().minute;

    int station = current;
    int next = link;
    int hour = currentHour;
    int minute = getMinuteRange(currentMinute);

    CollectionReference congestionCollection =
        FirebaseFirestore.instance.collection('Congestion');

    QuerySnapshot snapshot = await congestionCollection
        .where('station', isEqualTo: station)
        .where('next', isEqualTo: next)
        .where('hour', isEqualTo: hour)
        .where('minute', isEqualTo: minute)
        .get();

    int totalCongestion = 0;
    int numberOfMatchingDocuments = snapshot.docs.length;
    notifyListeners();
    if (numberOfMatchingDocuments > 0) {
      // 매칭되는 문서들의 cong 값 합산
      for (var doc in snapshot.docs) {
        totalCongestion += doc['cong'] as int;
      }

      print('일치하는 문서 수: $numberOfMatchingDocuments');
      print('총 혼잡도 값: $totalCongestion');

      return totalCongestion ~/ numberOfMatchingDocuments;
    } else {
      return -1;
    }
  }
}
