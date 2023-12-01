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

  @override
  void initState() {
    super.initState();
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return FontAwesomeIcons.solidFaceLaughBeam;
      case 1:
        return FontAwesomeIcons.solidFaceSmile;
      case 2:
        return FontAwesomeIcons.solidFaceMeh;
      case 3:
        return FontAwesomeIcons.solidFaceFrown;
      case 4:
        return FontAwesomeIcons.solidFaceTired;
      default:
        return Icons.error;
    }
  }

  Color _getColorForIndex(int index) {
    switch (index) {
      case 0:
        return const Color.fromARGB(255, 244, 238, 54);
      case 1:
        return const Color.fromARGB(255, 244, 206, 54);
      case 2:
        return const Color.fromARGB(255, 244, 165, 54);
      case 3:
        return const Color.fromARGB(255, 244, 130, 54);
      case 4:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  void toggleBookmark() {
    setState(() {
      widget.updateIsBookmark(!widget.isBkMk); // isBkMk 값을 토글합니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentTime = DateFormat('HH:mm').format(DateTime.now());
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
                          array = 1; // 또는 다른 값으로 변경
                        }); // 또는 다른 값으로 변경
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
                          color: Theme.of(context).cardColor,
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
                          child: Icon(
                            _getIconForIndex(
                              int.parse(widget.pCong[array]),
                            ),
                            color: _getColorForIndex(
                              int.parse(widget.pCong[array]),
                            ),
                            size: 40,
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
                                confg: widget.pCong[array],
                                line: widget.line[array],
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
                          color: Theme.of(context).cardColor,
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
                          child: Icon(
                            _getIconForIndex(
                              int.parse(widget.pCong[array]),
                            ),
                            color: _getColorForIndex(
                              int.parse(widget.pCong[array]),
                            ),
                            size: 40,
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
                                confg: widget.nCong[array],
                                line: widget.line[array],
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
