import 'package:flutter/material.dart';
import 'package:test1/algorithm_code/graph.dart';
import 'package:test1/Provider/data_provider.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/main.dart';
import 'package:test1/Interface/menu.dart';
import 'package:test1/Congestion/congestion.dart';
import 'package:intl/intl.dart';
import 'package:test1/notification_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//drawRouteResult에서 반환값으로 사용하기 위한 클래스
class StationRouteResult {
  final List<int> saveline; //경로의 호선
  final int transcount; //환승 횟수
  final List<dynamic> station; //역

  StationRouteResult(this.saveline, this.transcount, this.station);
}

class RouteResults extends StatefulWidget {
  final String startStation;
  final String arrivStation;
  final bool check;

  const RouteResults({
    super.key,
    required this.startStation,
    required this.arrivStation,
    required this.check,
  });

  @override
  State<RouteResults> createState() => _RouteResultsState();
}

class _RouteResultsState extends State<RouteResults> {
  UserProvider userProvider = UserProvider();

  bool isLoading = true; //로딩 여부
  String currentSearch =
      "recommend"; //현재 경로 검색 모드 -> "recommend", shortest, cheapest
  late List<int> optmPath; //추천 경로
  late List<int> timePath; //최단 시간 경로
  late List<int> costPath; //최소 비용 경로

  late List<int> optimum; //시간 + 비용 가중치 : UI에 나타나진 않고 가중치 계산용
  late List<int> minTime; //최단 시간 가중치
  late List<int> minCost; //최소 비용 가중치

  late int timeOfOptmPath; //추천 경로의 소요 시간
  late int costOfOptmPath; //추천 경로의 비용
  late int costOfTimePath; //최단 시간 경로의 비용
  late int timeOfCostPath; //최단 비용 경로의 시간

  late List<int> currentpath; //현재 할당 받을 경로

  //RouteResultContainer클래스에서 시간과 비용을 나타내주는 변수
  late int time;
  late int cost;

  //drawStationRoute메소드에서 환승 횟수와 경로의 호선을 저장하는 변수
  late int transcount;

  //위의 환승횟수와 경로의 호선을 추천 경로, 최소 비용 경로, 최단 시간 경로 3가지로 객체선언하여 구분한 변수
  late int optmcount;
  late List<int> optmtrans;
  late List<dynamic> optmstation;
  late int timecount;
  late List<int> timetrans;
  late List<dynamic> timestation;
  late int costcount;
  late List<int> costtrans;
  late List<dynamic> coststation;

  late DataProvider dataProvider;

  late int travelTime;
  late bool isBook;

  //클래스 진입 시 초기화
  @override
  void initState() {
    NotificationService.init();
    Future.delayed(const Duration(seconds: 3),
        NotificationService.requestNotificationPermission());
    super.initState();

    isBook = false;
    checkBookRoute();

    optmPath = [];
    timePath = [];
    costPath = [];

    optimum = [];
    minTime = [];
    minCost = [];

    timeOfOptmPath = 0;
    costOfOptmPath = 0;
    costOfTimePath = 0;
    timeOfCostPath = 0;

    currentSearch = "recommend";

    currentpath = optmPath;

    optmcount = 0;
    optmtrans = [];
    optmstation = [];
    timecount = 0;
    timetrans = [];
    timestation = [];
    costcount = 0;
    costtrans = [];
    coststation = [];

    dataProvider = DataProvider();

    travelTime = 0;

    fetchData(); // 그래프 데이터 가져오기
  }

  //경로 즐겨찾기 여부 확인
  void checkBookRoute() async {
    isBook = await userProvider.isRouteBookmarked(
        widget.startStation, widget.arrivStation);
  }

  //그래프 객체를 선언하고 각 그래프의 변수 선언
  Future<void> fetchData() async {
    await dataProvider.fetchDocumentList();

    Graph optmGraph = dataProvider.getOptmGraph();
    Graph timeGraph = dataProvider.getTimeGraph();
    Graph costGraph = dataProvider.getCostGraph();

    setState(() {
      optimum = optmGraph.dijkstra(
        int.parse(widget.startStation),
        int.parse(widget.arrivStation),
        optmPath,
      );

      minCost = costGraph.dijkstra(
        int.parse(widget.startStation),
        int.parse(widget.arrivStation),
        costPath,
      );

      minTime = timeGraph.dijkstra(
        int.parse(widget.startStation),
        int.parse(widget.arrivStation),
        timePath,
      );
    });

    timeOfOptmPath = weightOfPath(dataProvider.getTimeGraph(), optmPath);

    costOfOptmPath = weightOfPath(dataProvider.getCostGraph(), optmPath);

    timeOfCostPath = weightOfPath(dataProvider.getTimeGraph(), costPath);

    costOfTimePath = weightOfPath(dataProvider.getCostGraph(), timePath);

    StationRouteResult optm = await drawStationRoute(optmPath);
    StationRouteResult time = await drawStationRoute(timePath);
    StationRouteResult cost = await drawStationRoute(costPath);

    setState(() {
      optmcount = optm.transcount;
      optmtrans = optm.saveline;
      optmstation = optm.station;

      timecount = time.transcount;
      timetrans = time.saveline;
      timestation = time.station;

      costcount = cost.transcount;
      costtrans = cost.saveline;
      coststation = cost.station;
    });

    // 데이터 가져온 후 UI 업데이트
    setState(() {
      isLoading = false;
    });
  }

  //경로 그려주는 함수 -> 배열에 호선 번호 삽입 환승하는 역일 시 환승 전 호선과 환승 후 호선 삽입
  Future<StationRouteResult> drawStationRoute(List<int> path) async {
    int leng = path.length - 1; //첫번째 역 배열 위치
    int prevline; //환승여부 판정할때 전역의 호선과 다른지 판단하기 위한 전역 호선 번호
    List<int> saveline = [];
    List<dynamic> station = [];
    transcount = 0; //환승횟수

    //첫번쨰 역 처리
    await dataProvider.searchData(path[leng]);

    if (217 == path[leng]) {
      saveline.add(dataProvider.line[0]);
      prevline = dataProvider.line[0];
    } else {
      if (int.parse(dataProvider.nName[0]) == path[leng - 1] ||
          int.parse(dataProvider.pName[0]) == path[leng - 1]) {
        saveline.add(dataProvider.line[0]);
        prevline = dataProvider.line[0];
      } else {
        saveline.add(dataProvider.line[1]);
        prevline = dataProvider.line[1];
      }
    }
    //첫번째역의 호선을 저장하고 그호선을 다음 역과 비교
    for (int i = 1; i < leng; i++) {
      await dataProvider.searchData(path[leng - i]);

      //환승 여부
      //환승 불가 역
      if (dataProvider.line.length == 1) {
        saveline.add(dataProvider.line[0]);
        station.add(path[leng - i]);

        //환승가능역
      } else {
        if (int.parse(dataProvider.nName[0]) == path[leng - i - 1] ||
            int.parse(dataProvider.pName[0]) == path[leng - i - 1]) {
          //환승 안할 경우
          if (prevline == dataProvider.line[0]) {
            saveline.add(dataProvider.line[0]);
            station.add(path[leng - i]);
          }

          //환승 할 경우
          else {
            saveline.add(prevline);
            saveline.add(-1);
            saveline.add(dataProvider.line[0]);
            station.add(path[leng - i]);
            station.add("환승 ${dataProvider.line[0]}호선");
            station.add(path[leng - i]);
            prevline = dataProvider.line[0];
            transcount += 1;
          }
        } else {
          if (prevline == dataProvider.line[1]) {
            saveline.add(dataProvider.line[1]);
            station.add(path[leng - i]);
          }

          //환승 할 경우
          else {
            saveline.add(prevline);
            saveline.add(-1);
            saveline.add(dataProvider.line[1]);
            station.add(path[leng - i]);
            station.add("환승 ${dataProvider.line[1]}호선");
            station.add(path[leng - i]);
            prevline = dataProvider.line[1];
            transcount += 1;
          }
        }
      }
    }

    saveline.add(prevline);

    return StationRouteResult(saveline, transcount, station);
  }

  //경로에 따라 경로 그래프를 빌드하는 메소드
  Widget routeContainer(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == "앱 추천 경로") {
            currentSearch = "recommend";
            currentpath = optmPath;
          } else if (text == "최단 시간") {
            currentSearch = "shortest";
            currentpath = timePath;
          } else if (text == "최소 비용") {
            currentSearch = "cheapest";
            currentpath = costPath;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).canvasColor
              : Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        width: 90,
        height: 45,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget routeResultContainer(List currentpath) {
    int count = 0;
    List line = [];
    List station = [];

    if (currentpath == optmPath) {
      time = ((timeOfOptmPath) / 60).round();
      cost = costOfOptmPath;
      count = optmcount;
      line = List<int>.from(optmtrans);
      station = optmstation;
    } else if (currentpath == timePath) {
      time = (minTime[int.parse(widget.arrivStation)] / 60).round();
      cost = costOfTimePath;
      count = timecount;
      line = List<int>.from(timetrans);
      station = timestation;
    } else if (currentpath == costPath) {
      time = ((timeOfCostPath) / 60).round();
      cost = minCost[int.parse(widget.arrivStation)];
      count = costcount;
      line = List<int>.from(costtrans);
      station = coststation;
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "소요시간",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.5,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isBook) {
                          userProvider.removeBookmarkRoute(
                              widget.startStation, widget.arrivStation);
                          isBook = false;
                        } else {
                          userProvider.addBookmarkRoute(
                              widget.startStation, widget.arrivStation);
                          isBook = true;
                        }
                      });
                    },
                    child: Icon(
                      isBook ? Icons.star : Icons.star_border_outlined,
                      size: 35,
                      color: isBook
                          ? const Color.fromARGB(255, 224, 210, 91)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6.5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      "$time분",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30.5,
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          "환승 $count번",
                          style: const TextStyle(
                            fontSize: 16.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5.5,
                  ),
                  Container(
                    width: 1.5, // 선의 너비 설정 (옵션)
                    height: 25, // 선의 두께 설정 (옵션)
                    color: Colors.grey, // 선의 색상 설정 (옵션)
                  ),
                  const SizedBox(
                    width: 12.5,
                  ),
                  SizedBox(
                    width: 75,
                    child: Text(
                      "$cost원",
                      style: const TextStyle(
                        fontSize: 16.5,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 1, // 선의 두께 설정 (옵션)
                color: Colors.grey, // 선의 색상 설정 (옵션)
              ),
              routeGraph(
                line,
                currentpath,
                station,
              ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 1, // 선의 두께 설정 (옵션)
                color: Colors.grey, // 선의 색상 설정 (옵션)
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () async {
                      if (currentpath == optmPath) {
                        travelTime = timeOfOptmPath;
                      } else if (currentpath == timePath) {
                        travelTime = timeOfCostPath;
                      } else if (currentpath == costPath) {
                        travelTime = timeOfCostPath;
                      }
                      //_scheduleAlarm(10);
                      NotificationService.showDelayedNotification(
                          travelTime - 60, '곧 도착 예정', '잠시 후 역에 도착합니다.');
                      print("알림 시작 버튼 터치");
                      //팝업 표시
                      bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('알림 시작'),
                                content: const Text(
                                    '알림이 시작되었습니다!\n도착 1분전에 알람이 울립니다.\n혼잡도 정보를 제공하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('아니오'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // 아니오를 누르면 false를 반환
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('예'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // 예를 누르면 true를 반환
                                    },
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;

                      if (confirm) {
                        if (currentpath == optmPath) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Congestion(
                                currentStaion:
                                    optmPath[timePath.length - 1].toString(),
                                linkStaion:
                                    optmPath[timePath.length - 2].toString(),
                                line: line[0],
                                confg: '0',
                              ),
                            ),
                          );
                        } else if (currentpath == timePath) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Congestion(
                                currentStaion:
                                    timePath[timePath.length - 1].toString(),
                                linkStaion:
                                    timePath[timePath.length - 2].toString(),
                                line: line[0],
                                confg: '0',
                              ),
                            ),
                          );
                        } else if (currentpath == costPath) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Congestion(
                                currentStaion:
                                    costPath[timePath.length - 1].toString(),
                                linkStaion:
                                    costPath[timePath.length - 2].toString(),
                                line: line[0],
                                confg: '0',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 80,
                        ),
                        SizedBox(
                          width: 50,
                          child: Icon(
                            FontAwesomeIcons.bell,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            "알림 시작",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //경로 그래프 빌드하는 메소드
  Expanded routeGraph(
      List<dynamic> line, List<dynamic> currentpath, List<dynamic> station) {
    String currentTime = DateFormat('HH:mm').format(DateTime.now());
    DateTime now = DateTime.now();
    DateTime offTime = now.add(Duration(minutes: time));
    String dropOffTime = DateFormat('HH:mm').format(offTime);

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    width: 40,
                    height: 40,
                    child: Align(
                        alignment: Alignment.center, child: Text(currentTime))),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: perlinedata(line[0]),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${line[0]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: perlinedata(line[0]),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "승차",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${currentpath[currentpath.length - 1]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.5,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                ),
              ],
            ),
            for (int i = 1; i < line.length - 1; i++) ...[
              Row(
                children: [
                  const SizedBox(
                    width: 90,
                  ),
                  Container(
                    width: 20,
                    height: 60,
                    decoration: BoxDecoration(
                      color: perlinedata(line[i]),
                    ),
                    child: Center(
                      child: Container(
                        width: 7.3,
                        height: 7.3,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            color: Color.fromARGB(255, 225, 213, 213)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 80,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${station[i - 1]}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ],
            Row(
              children: [
                SizedBox(
                    width: 40,
                    height: 40,
                    child: Align(
                        alignment: Alignment.center, child: Text(dropOffTime))),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: perlinedata(line[line.length - 1]),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${line[line.length - 1]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: perlinedata(line[line.length - 1]),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "하차",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${currentpath[0]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.5,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        if (widget.check == true) {
          return true; // 이벤트 처리를 여기서 마칩니다.
        } else {
          currentUI = 'home';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Menu()),
          );
          return false; // 이벤트 처리를 여기서 막습니다.
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: isLoading // 로딩 중일 때
            ? const Center(
                child: CircularProgressIndicator(), // 로딩 인디케이터를 보여줍니다.
              )
            : Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    width: double.infinity,
                    height: 125,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.angleLeft,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                if (widget.check == true) {
                                } else {
                                  currentUI = 'home';
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Menu()),
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              width: 95,
                            ),
                            Container(
                              height: 40.5,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .primaryColorDark, // 테두리 색상 설정
                                    width: 0.75, // 테두리 두께 설정
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      widget.startStation,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 22.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 6.5,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.rightLong,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    const SizedBox(
                                      width: 6.5,
                                    ),
                                    Text(
                                      widget.arrivStation,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 22.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            routeContainer(
                                "앱 추천 경로", currentSearch == "recommend"),
                            routeContainer(
                                "최단 시간", currentSearch == "shortest"),
                            routeContainer(
                                "최소 비용", currentSearch == "cheapest"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: routeResultContainer(currentpath))
                ],
              ),
      ),
    );
  }
}
