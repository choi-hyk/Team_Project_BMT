import 'package:flutter/material.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
              width: 50,
              height: 10,
            ),
            const SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [],
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
              height: 10,
            ),
            const Text("즐겨찾기"),
            SizedBox(
              height: 300,
              child: Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      for (var i = 0; i < 4; i++)
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey, // 테두리 색상
                                  width: 1, // 테두리 두께
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
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 1, // 구분선의 높이
              thickness: 1, // 구분선의 두께
              color: Colors.grey, // 구분선의 색상
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("최신 글"),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        for (var i = 0; i < 10; i++)
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: Colors.grey, // 테두리 색상
                                    width: 1.0, // 테두리 두께
                                  ),
                                ),
                                width: double.infinity,
                                height: 160,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
