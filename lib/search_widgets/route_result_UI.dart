import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test1/algorithm_code/graph.dart';
import 'package:test1/provider_code/data_provider.dart';

class RouteResults extends StatefulWidget {
  final String startStation;
  final String arrivStation;
  const RouteResults(
      {super.key, required this.startStation, required this.arrivStation});

  @override
  State<RouteResults> createState() => _RouteResultsState();
}

class _RouteResultsState extends State<RouteResults> {
  String currentSearch = "recommend";
  late List<int> timePath;
  late List<int> costPath;
  late List<int> minTime;
  late List<int> minCost;

  late DataProvider dataProvider;
  // ignore: unused_field
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    timePath = []; //시간 경로 저장
    costPath = []; //비용 경로 저장
    minTime = [];
    minCost = [];
    dataProvider = DataProvider();
    fetchData(); // 그래프 데이터 가져오기
  }

  void fetchData() async {
    await dataProvider.fetchDocumentList();
    Graph timeGraph = dataProvider.getTimeGraph();
    Graph costGraph = dataProvider.getCostGraph();
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

    setState(() {
      _isLoading = false;
    }); // 데이터 가져온 후 UI 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                width: double.infinity,
                height: 115,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RouteContainer(
                        context, "앱 추천 경로", currentSearch == "recommend"),
                    RouteContainer(
                        context, "최단 시간", currentSearch == "shortest"),
                    RouteContainer(
                        context, "최소 비용", currentSearch == "cheapest"),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: RouteResultContainer(),
              ),
            ],
          ),
          Positioned(
            top: 17.5, // 뒤로가기 버튼의 위치 조정 (값을 조절하여 원하는 위치로 이동 가능)
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.angleLeft,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 뒤로가기 기능 수행
              },
            ),
          ),
          Positioned(
            top: 20.5,
            left: 129,
            child: Container(
              height: 40.5,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark, // 테두리 색상 설정
                    width: 0.75, // 테두리 두께 설정
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      widget.startStation,
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
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
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 22.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget RouteContainer(BuildContext context, String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == "앱 추천 경로") {
            currentSearch = "recommend";
          } else if (text == "최단 시간") {
            currentSearch = "shortest";
            print("최단 시간: ${minTime[int.parse(widget.arrivStation)]}");
            print(
                "${widget.startStation}역에서 ${widget.arrivStation}역 까지의 최단 시간: ${minTime[int.parse(widget.arrivStation)]}");
            print("최단 경로: $timePath");
          } else if (text == "최소 비용") {
            currentSearch = "cheapest";
            print("최단 시간: ${minCost[int.parse(widget.arrivStation)]}");
            print(
                "${widget.startStation}역에서 ${widget.arrivStation}역 까지의 최소 비용: ${minTime[int.parse(widget.arrivStation)]}");
            print("최단 경로: $costPath");
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).cardColor
              : Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        width: 90,
        height: 35,
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
}

class RouteResultContainer extends StatelessWidget {
  const RouteResultContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white),
        width: double.infinity,
        height: 648);
  }
}
