//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LostAndFound extends StatefulWidget {
  const LostAndFound({super.key});

  @override
  State<LostAndFound> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFound> {
  bool _isSearching = false;
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
            _isSearching = false;
            Navigator.pop(context); // 뒤로 가기 버튼을 누르면 현재 화면에서 빠져나감
          },
        ),
        title: _isSearching
            ? TextField(
                // 검색 모드에서는 검색 창을 표시
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: '검색어를 입력하세요',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (searchQuery) {
                  // 검색어 입력 시 동작할 작업 추가
                },
              )
            : const Text(
                '분실물 게시판',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching; // 검색 버튼을 누를 때 검색 모드 토글
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Column(
                    children: [
                      for (var i = 0; i < 10; i++)
                        Column(
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
        ]),
      ),
    );
  }
}
