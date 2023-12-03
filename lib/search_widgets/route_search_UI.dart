import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test1/StationMap.dart';
import 'package:test1/main.dart';
import 'package:test1/provider_code/data_provider.dart';
import 'package:test1/search_widgets/route_result_UI.dart';

class RouteSearch extends StatefulWidget {
  final String? startStation;
  final String? arrivStation;

  const RouteSearch({super.key, this.startStation, this.arrivStation});

  @override
  State<RouteSearch> createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch> {
  final TextEditingController _searchStartController = TextEditingController();
  final TextEditingController _searchStopoContraller = TextEditingController();
  final TextEditingController _searchArrivController = TextEditingController();

  String? _tempStartStation;
  String? _tempArrivStation;
  DataProvider dataProvider1 = DataProvider();
  DataProvider dataProvider2 = DataProvider();
  DataProvider dataProvider3 = DataProvider();

  bool isStopOver = false;

  @override
  void initState() {
    super.initState();
    // 검색 바에 특정 텍스트 설정
    if (widget.startStation != null) {
      _searchStartController.text = widget.startStation!;
    } else if (widget.arrivStation != null) {
      _searchArrivController.text = widget.arrivStation!;
    }
  }

//두 검색어를 스위치하는 함수
  void _swapSearchFields() {
    setState(() {
      _tempStartStation = _searchStartController.text;
      _tempArrivStation = _searchArrivController.text;

      _searchStartController.text = _tempArrivStation ?? '';
      _searchArrivController.text = _tempStartStation ?? '';
    });
  }

  Future<void> _searchRoute() async {
    String startStation = _searchStartController.text;

    String arrivStation = _searchArrivController.text;

    await dataProvider1.searchData(int.parse(startStation));
    await dataProvider2.searchData(int.parse(arrivStation));

    if (isStopOver) {
      String stopoStation = _searchStopoContraller.text;
      await dataProvider3.searchData(int.parse(stopoStation));

      if (!dataProvider1.found ||
          !dataProvider2.found ||
          !dataProvider3.found) {
        showSnackBar(context, const Text("존재하지 않는 역입니다"));
      } else if (startStation == stopoStation || stopoStation == arrivStation) {
        showSnackBar(context, const Text("서로 다른 역을 입력하십시오"));
      } else {
        // 네비게이션 및 데이터 전달
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RouteResults(
              startStation: startStation,
              arrivStation: arrivStation,
              stopoStation: stopoStation,
            ),
          ),
        );
      }
    } else {
      if (!dataProvider1.found || !dataProvider2.found) {
        showSnackBar(context, const Text("존재하지 않는 역입니다"));
      } else if (startStation == arrivStation) {
        showSnackBar(context, const Text("서로 다른 역을 입력하십시오"));
      } else {
        // 네비게이션 및 데이터 전달
        // 네비게이션 및 데이터 전달
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RouteResults(
                startStation: startStation, arrivStation: arrivStation),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 155,
            left: 6.5,
            right: 6.5,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              width: 500,
              height: 560,
              child: StationMap(
                onTapStation: (String stationKey) {
                  InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Image.asset(
                      "assets/images/노선도.png",
                      width: 500,
                      height: 560,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),
          ),

          // 검색 바
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                width: double.infinity,
                height: isStopOver ? 200 : 150, // is
                child: Padding(
                  padding: const EdgeInsets.only(top: 28.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 5.5,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 43.5,
                              ),
                              SizedBox(
                                width: 240,
                                child: TextField(
                                  controller: _searchStartController,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (String value) {
                                    int? searchStation = int.tryParse(value);
                                    if (searchStation != null) {
                                      _searchRoute();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 10,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    hintText: '출발 역',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        _searchStartController.clear();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6.5,
                          ),
                          if (isStopOver) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 43.5,
                                ),
                                SizedBox(
                                  width: 240,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _searchStopoContraller,
                                    onSubmitted: (String value) {
                                      int? searchStation = int.tryParse(value);
                                      if (searchStation != null) {
                                        _searchRoute();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 13,
                                        horizontal: 10,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      hintText: '경유 역',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                        onPressed: () {
                                          _searchStopoContraller.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(
                            height: 6.5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 43.5,
                              ),
                              SizedBox(
                                width: 240,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _searchArrivController,
                                  onSubmitted: (String value) {
                                    int? searchStation = int.tryParse(value);
                                    if (searchStation != null) {
                                      _searchRoute();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 10,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    hintText: '도착 역',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        _searchArrivController.clear();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 17,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.repeat,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              _swapSearchFields();
                            },
                          ),
                          const SizedBox(
                            height: 14,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.825),
              child: DraggableScrollableSheet(
                initialChildSize: 0.10,
                maxChildSize: 0.99,
                minChildSize: 0.10,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(13.0),
                          topRight: Radius.circular(13.0),
                        ),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      width: 379.5,
                      height: 640.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey),
                              width: 50,
                              height: 10,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Divider(
                              height: 1, // 구분선의 높이
                              thickness: 1, // 구분선의 두께
                              color: Colors.grey, // 구분선의 색상
                            ),
                            const Text("검색 기록"),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              // 최근 검색 섹션
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    for (var i = 0; i < 10; i++)
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5,
                                              ),
                                            ),
                                            width: double.infinity,
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            const Text("즐겨 찾기"),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 6.5,
                            ),
                            Expanded(
                              // 즐겨 찾기 섹션
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    for (var i = 0; i < 4; i++)
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                            ),
                                            width: double.infinity,
                                            height: 100,
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: 90,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "역,경로",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 90,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "장소",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 90,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 20.5, // 뒤로가기 버튼의 위치 조정 (값을 조절하여 원하는 위치로 이동 가능)
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
            top: 60.5, // 뒤로가기 버튼의 위치 조정 (값을 조절하여 원하는 위치로 이동 가능)
            left: 25,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Theme.of(context).canvasColor,
              ),
              child: IconButton(
                icon: isStopOver
                    ? Icon(
                        FontAwesomeIcons.minus,
                        color: Theme.of(context).primaryColorDark,
                      )
                    : Icon(
                        FontAwesomeIcons.plus,
                        color: Theme.of(context).primaryColorDark,
                      ),
                onPressed: () {
                  setState(() {
                    isStopOver = !isStopOver;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
