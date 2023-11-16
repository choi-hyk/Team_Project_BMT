import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RouteSearch extends StatefulWidget {
  const RouteSearch({super.key});

  @override
  State<RouteSearch> createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            width: double.infinity,
            height: 140,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        ), // 뒤로 가기 아이콘
                        onPressed: () {
                          Navigator.pop(context); // 뒤로 가기 버튼을 누르면 현재 화면에서 빠져나감
                        },
                      ),
                      const Text(
                        "경로 검색",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 143,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onSubmitted: (String value) {},
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: '출발역',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      const Icon(
                        FontAwesomeIcons.arrowRight,
                        size: 25.0,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      SizedBox(
                        width: 143,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onSubmitted: (String value) {},
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            hintText: '도착역',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.5,
                  ),
                ],
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("최근 검색")],
          ),
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
                            color: const Color.fromARGB(255, 255, 255, 255),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("즐겨 찾기")],
          ),
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
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          width: double.infinity,
                          height: 100,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 90,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "역,경로",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "장소",
                                    style: TextStyle(fontSize: 15),
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
    );
  }
}
