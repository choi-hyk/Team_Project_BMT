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
  final TextEditingController _searchArrivController = TextEditingController();

  String? _tempStartStation;
  String? _tempArrivStation;
  String? tappedStationKey;

  DataProvider dataProvider1 = DataProvider();
  DataProvider dataProvider2 = DataProvider();

  bool isSearchong = false;

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

  void onTapStation(String stationKey) {
    setState(() {
      tappedStationKey = stationKey;
    });
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
                onTapStation: onTapStation,
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
                height: 150, // is
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
                              FontAwesomeIcons.search,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              _searchRoute();
                            },
                          ),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 56,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: tappedStationKey !=
                        null // tappedStationKey가 존재할 때 텍스트를 표시
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _searchStartController.text =
                                          tappedStationKey!;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 2.0,
                                      ),
                                    ),
                                    width: 60,
                                    height: 35,
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '출발',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      color: perlinedata(
                                          int.parse(tappedStationKey!) ~/ 100)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Colors.white),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          tappedStationKey!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _searchArrivController.text =
                                          tappedStationKey!;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        width: 2.0,
                                      ),
                                    ),
                                    width: 60,
                                    height: 35,
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '도착',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Theme.of(context).canvasColor),
                          child: Center(
                            child: Text(
                              "Fast",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).cardColor),
                            ),
                          ),
                        ),
                      ), // tappedStationKey가 null일 경우 텍스트를 표시하지 않음
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
            top: 60.5,
            left: 25,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Theme.of(context).canvasColor,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              //광고배너 컨테이너
              width: double.infinity,
              height: 55.0,
              color: Colors.green,
              child: Image.asset(
                'assets/images/광고1.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
