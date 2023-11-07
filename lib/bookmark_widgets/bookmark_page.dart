import 'package:flutter/material.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ), // 뒤로 가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼을 누르면 현재 화면에서 빠져나감
          },
        ),
        title: const Text(
          '즐겨찾기',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Expanded(
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
                            color: Colors.grey, // 테두리 색상
                            width: 1, // 테두리 두께
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
      ),
    );
  }
}
