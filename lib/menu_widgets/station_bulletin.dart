import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class StationBulletin extends StatefulWidget {
  const StationBulletin({super.key});

  @override
  State<StationBulletin> createState() => _StationBulletinState();
}

class _StationBulletinState extends State<StationBulletin> {
  bool _isSearching = false;
  int selectedStation = 101; // Initial selected station

  CollectionReference product =
      FirebaseFirestore.instance.collection('Bulletin_Board');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController stationController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    titleController.text = documentSnapshot['title'];
    contentController.text = documentSnapshot['content'];
    userController.text = documentSnapshot['User_ID'];
    stationController.text = documentSnapshot['station_ID'];

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
                  controller: titleController,
                  decoration: const InputDecoration(labelText: '제목'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: '내용'),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                  controller: userController,
                  decoration: const InputDecoration(labelText: '작성자'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String title = titleController.text;
                    final String content = contentController.text;
                    final String station = stationController.text;
                    final String user = userController.text;

                    await product.doc(documentSnapshot.id).update(
                      {
                        "title": title,
                        "content": content,
                        "station_ID": station,
                        "User_ID": user,
                        "updated_at": FieldValue.serverTimestamp(),
                      },
                    );

                    titleController.text = "";
                    contentController.text = "";
                    stationController.text = "";
                    userController.text = "";
                    Navigator.of(context).pop();
                  },
                  child: const Text('수정'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                  controller: titleController,
                  decoration: const InputDecoration(labelText: '제목'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: '내용'),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                  controller: userController,
                  decoration: const InputDecoration(labelText: '작성자'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String title = titleController.text;
                    final String content = contentController.text;
                    final String station = stationController.text;
                    final String user = userController.text;

                    await product.add({
                      'title': title,
                      'content': content,
                      'station_ID': station,
                      'User_ID': user,
                      'created_at': FieldValue.serverTimestamp(),
                    });

                    titleController.text = "";
                    contentController.text = "";
                    stationController.text = "";
                    userController.text = "";
                    Navigator.of(context).pop();
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

  Future<void> _delete(String productId) async {
    await product.doc(productId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            _isSearching = false;
            Navigator.pop(context);
          },
        ),
        title: _isSearching
            ? TextField(
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: '검색어를 입력하세요',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (searchQuery) {},
              )
            : const Text(
                '게시판',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          _isSearching
              ? Container() // Empty container when searching
              : DropdownButton<int>(
                  value: selectedStation,
                  items: const [
                    DropdownMenuItem<int>(
                      value: 101,
                      child: Text('101호'),
                    ),
                    DropdownMenuItem<int>(
                      value: 102,
                      child: Text('102호'),
                    ),
                    DropdownMenuItem<int>(
                      value: 104,
                      child: Text('104호'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStation = value!;
                    });
                  },
                ),
          /*IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),*/
        ],
      ),
      body: StreamBuilder(
        stream:
            product.where('station_ID', isEqualTo: selectedStation).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                DateTime createdAt =
                    (documentSnapshot['created_at'] as Timestamp).toDate();

                String formattedDate =
                    DateFormat('yyyy년-MM월-dd일 a h시 mm분', 'ko_KR')
                        .format(createdAt);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${documentSnapshot['station_ID']}호',
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),*/
                      const SizedBox(height: 5),
                      ListTile(
                        title: Text(
                          documentSnapshot['title'],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(documentSnapshot['content']),
                            const SizedBox(height: 5),
                            Text('사용자: ${documentSnapshot['User_ID']}'),
                            const SizedBox(height: 5),
                            Text('작성일: $formattedDate'),
                            const SizedBox(height: 5),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _update(documentSnapshot);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  _delete(documentSnapshot.id);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _create();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text('글쓰기'),
      ),
    );
  }
}
