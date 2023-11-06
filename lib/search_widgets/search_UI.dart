import 'package:flutter/material.dart';

//길찾기 UI
//최단 시간, 최소 비용, 최적 경로 제공 -> 사용자 설정으로 순서 변경 가능
//사용자 설정 UI 제공 -> default 즐겨찾기 경로, 사용자 설정으로 변경 가능
class SearchUI extends StatefulWidget {
  const SearchUI({super.key});

  @override
  State<SearchUI> createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13.0),
          topRight: Radius.circular(13.0),
        ),
      ),
      width: 379.5,
      height: 640.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
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
                  width: 240,
                ),
                const Icon(
                  Icons.star_border_outlined, // 아이콘 종류
                  size: 35, // 아이콘 크기 설정
                ),
              ],
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
                  child: const Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_left, // 아이콘 종류
                          size: 24.0, // 아이콘 크기 설정
                          color: Colors.white, // 아이콘 색상 설정
                        ),
                        Text(
                          "전역",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 230,
                        ),
                        Text(
                          "다음 역",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
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
                  child: const Align(
                    alignment: Alignment.center,
                    //역이름 들어가는 곳
                    child: Text(
                      "역이름",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 212, 215, 216),
                borderRadius: BorderRadius.circular(50.0),
              ),
              width: double.infinity,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
