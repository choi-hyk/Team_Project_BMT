import 'package:flutter/material.dart';
import 'package:test1/main.dart';
import 'route_search_UI.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StationData extends StatefulWidget {
  final List line;
  final String name;
  final bool cStore;
  final bool nRoom;
  final List nName;
  final List pName;
  final List nCong;
  final List pCong;

  const StationData({
    Key? key,
    required this.line,
    required this.name,
    required this.cStore,
    required this.nRoom,
    required this.nCong,
    required this.pCong,
    required this.nName,
    required this.pName,
  }) : super(key: key);

  @override
  State<StationData> createState() => _StationDataState();
}

class _StationDataState extends State<StationData> {
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
                  const Icon(
                    Icons.star_border_outlined,
                    size: 35,
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
              child: Text("혼잡도 정보"),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  width: 160,
                  height: 120,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.pCong[array],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  width: 160,
                  height: 120,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.nCong[array],
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
