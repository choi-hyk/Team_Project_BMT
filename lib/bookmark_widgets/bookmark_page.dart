import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  CollectionReference product =
      FirebaseFirestore.instance.collection('Bookmark_Station');

  final TextEditingController stationController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  CollectionReference routeCollection =
      FirebaseFirestore.instance.collection('Bookmark_Route');

  final TextEditingController station1Controller = TextEditingController();
  final TextEditingController station2Controller = TextEditingController();
  final TextEditingController placeRouteController = TextEditingController();
  final TextEditingController userRouteController = TextEditingController();

  Future<void> _createRoute() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                TextField(
                  controller: station1Controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: '출발역 호선'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: station2Controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: '도착역 호선'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: placeRouteController,
                  decoration: const InputDecoration(labelText: '장소'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: userRouteController,
                  decoration: const InputDecoration(labelText: '작성자'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final int station1 =
                        int.tryParse(station1Controller.text) ?? 0;
                    final int station2 =
                        int.tryParse(station2Controller.text) ?? 0;
                    final String place = placeRouteController.text;
                    final String user = userRouteController.text;

                    if (station1 != 0 && station2 != 0) {
                      // Bookmark_Route 테이블에 데이터 추가
                      await routeCollection.add({
                        'Station1_ID': station1,
                        'Station2_ID': station2,
                        'place': place,
                        'User_ID': user,
                      });

                      station1Controller.text = "";
                      station2Controller.text = "";
                      placeRouteController.text = "";
                      userRouteController.text = "";

                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('출발역과 도착역은 필수 입력 항목입니다.'),
                        ),
                      );
                    }
                  },
                  child: const Text('작성'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 즐겨찾기 추가
  Future<void> _create() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                TextField(
                  controller: stationController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: '호선'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: placeController,
                  decoration: const InputDecoration(labelText: '장소'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(labelText: '작성자'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final int station =
                        int.tryParse(stationController.text) ?? 0;
                    final String place = placeController.text;
                    final String user = userController.text;

                    if (station != 0 && place.isNotEmpty) {
                      // 추가
                      await product.add({
                        'Station_ID': station,
                        'place': place,
                        'User_ID': user,
                      });

                      stationController.text = "";
                      placeController.text = "";
                      userController.text = "";

                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('호선과 장소는 필수 입력 항목입니다.'),
                        ),
                      );
                    }
                  },
                  child: const Text('작성'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 즐겨찾기 삭제
  Future<void> _delete(String productId) async {
    await product.doc(productId).delete();
  }

  // 즐겨찾기 삭제: Bookmark_Route 테이블
  Future<void> _deleteRoute(String routeId) async {
    await routeCollection.doc(routeId).delete();
  }

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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bookmark_Station 데이터 표시
          StreamBuilder(
            stream: product.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              print("Bookmark_Station 데이터: ${streamSnapshot.data}");
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                      ),
                      color: Colors.white, // 흰색 배경
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${documentSnapshot['Station_ID']}',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        documentSnapshot['place'],
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: IconButton(
                                      onPressed: () {
                                        _delete(documentSnapshot.id);
                                      },
                                      icon: const Icon(Icons.star),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 굵은 선 추가
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),

          // Bookmark_Route 데이터 표시
          StreamBuilder(
            stream: routeCollection.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> routeSnapshot) {
              print("Bookmark_Route 데이터: ${routeSnapshot.data}");
              if (routeSnapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: routeSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot routeDocumentSnapshot =
                        routeSnapshot.data!.docs[index];
                    return Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                      ),
                      color: Colors.white, // 흰색 배경
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${routeDocumentSnapshot['Station1_ID']} > ${routeDocumentSnapshot['Station2_ID']}',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '${routeDocumentSnapshot['place']}',
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: IconButton(
                                      onPressed: () {
                                        _deleteRoute(routeDocumentSnapshot.id);
                                      },
                                      icon: const Icon(Icons.star),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 굵은 선 추가
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _createRoute(); // 즐겨찾기 추가 메소드 호출
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text('글 쓰기'),
      ),
    );
  }
}
