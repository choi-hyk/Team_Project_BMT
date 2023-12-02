import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test1/main.dart';
import 'package:test1/prov_conf.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'route_search_UI.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StationData extends StatefulWidget {
  final void Function(bool) updateIsBookmark;
  final List line;
  final String name;
  final bool cStore;
  final bool nRoom;
  bool isBkMk;
  final List nName;
  final List pName;
  final List nCong;
  final List pCong;

  // ignore: prefer_const_constructors_in_immutables
  StationData({
    Key? key,
    required this.line,
    required this.name,
    required this.cStore,
    required this.nRoom,
    required this.isBkMk,
    required this.nCong,
    required this.pCong,
    required this.nName,
    required this.pName,
    required this.updateIsBookmark,
  }) : super(key: key);

  @override
  State<StationData> createState() => _StationDataState();
}

class _StationDataState extends State<StationData> {
  UserProvider userProvider = UserProvider();

  DateTime nowtime = DateTime.now();

  String currentTime = DateFormat('HH:mm').format(DateTime.now());
  int currentHour = DateTime.now().hour;
  int currentMinute = DateTime.now().minute;

  int congestionN = -1;
  int congestionP = -1;

  bool isRunTime = false;

  @override
  void initState() {
    super.initState();
    calculateIsRunTime();
    loadCongestionData();
  }

  void toggleBookmark() {
    setState(() {
      widget.updateIsBookmark(!widget.isBkMk); // isBkMk 값을 토글합니다.
    });
  }

  Future<void> loadCongestionData() async {
    int congestionDataN = await getCongestionData(true);
    int congestionDataP = await getCongestionData(false);

    setState(() {
      congestionN = congestionDataN; // 혼잡도 값을 상태로 업데이트
      congestionP = congestionDataP;
    });
  }

  Future<int> getCongestionData(bool direct) async {
    int station = int.parse(widget.name);
    bool direction = direct;
    int line = widget.line[array];
    int hour = currentHour;
    int minute = getMinuteRange(currentMinute);

    CollectionReference congestionCollection =
        FirebaseFirestore.instance.collection('Congestion');

    QuerySnapshot snapshot = await congestionCollection
        .where('station', isEqualTo: station)
        .where('direction', isEqualTo: direction)
        .where('line', isEqualTo: line)
        .where('hour', isEqualTo: hour)
        .where('minute', isEqualTo: minute)
        .get();

    int totalCongestion = 0;
    int numberOfMatchingDocuments = snapshot.docs.length;

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

  void calculateIsRunTime() {
    setState(() {
      isRunTime = currentHour < 22 && currentHour >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      width: 400.5,
      height: 710.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        array = 0;
                        loadCongestionData();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: perlinedata(widget.line[0]),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      width: 50,
                      height: 25,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.line[0].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3.5,
                  ),
                  if (widget.line.length == 2)
                    InkWell(
                      onTap: () {
                        setState(() {
                          array = 1;
                          loadCongestionData();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: perlinedata(widget.line[1]),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        width: 50,
                        height: 25,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.line[1].toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  widget.line.length == 2
                      ? const SizedBox(width: 90)
                      : const SizedBox(width: 140),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteSearch(
                            startStation: widget.name,
                            arrivStation: null,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
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
                  const SizedBox(
                    width: 1.5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteSearch(
                            startStation: null,
                            arrivStation: widget.name,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 2.0,
                        ),
                      ),
                      width: 60,
                      height: 35,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "도착",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6.5,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (widget.isBkMk) {
                          toggleBookmark();
                          userProvider.removeBookmarkStation(widget.name);
                        } else {
                          toggleBookmark();
                          userProvider.addBookmarkStation(widget.name);
                        }
                      });
                    },
                    child: Icon(
                      widget.isBkMk ? Icons.star : Icons.star_border_outlined,
                      size: 35,
                      color: widget.isBkMk
                          ? const Color.fromARGB(255, 224, 210, 91)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: perlinedata(widget.line[array]),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      width: 400,
                      height: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_left,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            Text(
                              widget.pName[array],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 230,
                            ),
                            Text(
                              widget.nName[array],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              size: 24.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: perlinedata(widget.line[array]),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  width: 160,
                  height: 80,
                  child: const Align(
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  width: 120,
                  height: 50,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "혼잡도 정보",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Text(
              currentTime,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isRunTime) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.pName[array] == "종점역") ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          width: 160,
                          height: 120,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "종점역입니다",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 175.1,
                          height: 46,
                        ),
                      ],
                    ),
                  ] else ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                          width: 160,
                          height: 120,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  getIconForIndex(
                                    congestionP,
                                  ),
                                  color: getColorForIndex(congestionP),
                                  size: 40,
                                ),
                                getConfText(congestionP),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProvConf(
                                  currentStaion: widget.name,
                                  linkStaion: widget.pName[array],
                                  confg: congestionP.toString(),
                                  line: widget.line[array],
                                  direction: false,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Theme.of(context).canvasColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.pName[array]}역 방면 혼잡도 정보 제공",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (widget.nName[array] == "종점역") ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          width: 160,
                          height: 120,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "종점역입니다",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 175.1,
                          height: 46,
                        ),
                      ],
                    ),
                  ] else ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                          width: 160,
                          height: 120,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  getIconForIndex(congestionN),
                                  color: getColorForIndex(congestionN),
                                  size: 40,
                                ),
                                getConfText(congestionN),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProvConf(
                                  currentStaion: widget.name,
                                  linkStaion: widget.nName[array],
                                  confg: congestionN.toString(),
                                  line: widget.line[array],
                                  direction: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Theme.of(context).canvasColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.nName[array]}역 방면 혼잡도 정보 제공",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Theme.of(context).primaryColor),
                child: const Center(
                  child: Text(
                    "지하철 운영 시간이 아닙니다.",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("시설정보"),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    FontAwesomeIcons.toilet,
                    color: Theme.of(context).primaryColorDark,
                    size: 45.0,
                  ),
                  if (widget.cStore)
                    Icon(
                      FontAwesomeIcons.store,
                      color: Theme.of(context).primaryColorDark,
                      size: 45.0,
                    ),
                  if (widget.nRoom)
                    Icon(
                      FontAwesomeIcons.personBreastfeeding,
                      color: Theme.of(context).primaryColorDark,
                      size: 45.0,
                    ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("역 게시판"),
          ],
        ),
      ),
    );
  }
}
