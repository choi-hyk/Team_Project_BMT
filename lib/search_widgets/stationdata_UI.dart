import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

//길찾기 UI
//최단 시간, 최소 비용, 최적 경로 제공 -> 사용자 설정으로 순서 변경 가능
//사용자 설정 UI 제공 -> default 즐겨찾기 경로, 사용자 설정으로 변경 가능
class StationData extends StatefulWidget {
  final String stationId; //전달받은 역 id
  final String name; //전달받은 역 이름
  final String next; //전달받은 다음역
  final String prev; //전달받은 전역
  final bool toilet;
  final bool cStore;
  final bool nursingRoom;

  const StationData({
    super.key,
    required this.stationId,
    required this.name,
    required this.next,
    required this.prev,
    required this.toilet,
    required this.cStore,
    required this.nursingRoom,
  });

  @override
  State<StationData> createState() => _StationDataState();
}

class _StationDataState extends State<StationData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(13.0),
          topRight: Radius.circular(13.0),
        ),
        border: Border.all(
          color: Colors.grey, // 테두리 색상
          width: 1.5, // 테두리 두께
        ),
      ),
      width: 379.5,
      height: 640.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(50.0)),
                    width: 50,
                    height: 25,
                  ),
                  const SizedBox(
                    width: 140,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0), // 테두리 색상
                        width: 2.0, // 테두리 두께
                      ),
                    ),
                    width: 60,
                    height: 35,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        '출발',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0), // 테두리 색상
                        width: 2.0, // 테두리 두께
                      ),
                    ),
                    width: 60,
                    height: 35,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "도착",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.star_border_outlined, // 아이콘 종류
                    size: 35, // 아이콘 크기 설정
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1, // 구분선의 높이
              thickness: 1, // 구분선의 두께
              color: Colors.grey, // 구분선의 색상
            ),
            const SizedBox(
              height: 15,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                //설정 값 : 호선 색, 해당 역, 전 역, 다음 역
                Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(50.0)),
                  width: 400,
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_left, // 아이콘 종류
                          size: 24.0, // 아이콘 크기 설정
                          color: Colors.white, // 아이콘 색상 설정
                        ),
                        Text(
                          widget.prev,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 230,
                        ),
                        Text(
                          widget.next,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right, // 아이콘 종류
                          size: 24.0, // 아이콘 크기 설정
                          color: Colors.white, // 아이콘 색상 설정
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(50.0)),
                  width: 160,
                  height: 80,
                  child: const Align(
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)),
                  width: 120,
                  height: 50,
                  child: Align(
                    alignment: Alignment.center,
                    //역이름 들어가는 곳
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
              child: Text("열차 도착 정보"),
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
                      color: Colors.grey, // 테두리 색상
                      width: 1.0, // 테두리 두께
                    ),
                  ),
                  width: 160,
                  height: 120,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey, // 테두리 색상
                      width: 1.0, // 테두리 두께
                    ),
                  ),
                  width: 160,
                  height: 120,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1, // 구분선의 높이
              thickness: 1, // 구분선의 두께
              color: Colors.grey, // 구분선의 색상
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
                  if (widget.toilet)
                    Icon(
                      FontAwesomeIcons.toilet, // 화장실 아이콘
                      color: Theme.of(context).primaryColorDark, // 원하는 색상
                      size: 45.0, // 원하는 크기
                    ),
                  if (widget.cStore)
                    Icon(
                      FontAwesomeIcons.store, // 화장실 아이콘
                      color: Theme.of(context).primaryColorDark, // 원하는 색상
                      size: 45.0, // 원하는 크기
                    ),
                  if (widget.nursingRoom)
                    Icon(
                      FontAwesomeIcons.personBreastfeeding, // 화장실 아이콘
                      color: Theme.of(context).primaryColorDark, // 원하는 색상
                      size: 45.0, // 원하는 크기
                    ),
                ],
              ),
            ),
            const Divider(
              height: 1, // 구분선의 높이
              thickness: 1, // 구분선의 두께
              color: Colors.grey, // 구분선의 색상
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
