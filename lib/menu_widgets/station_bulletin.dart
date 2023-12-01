import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:test1/menu_widgets/comment_page.dart';

class StationBulletin extends StatefulWidget {
  const StationBulletin({super.key});

  @override
  State<StationBulletin> createState() => _StationBulletinState();
}

class _StationBulletinState extends State<StationBulletin> {
  final bool _isSearching = false;
  List<int> stationIds = []; // station_ID 목록을 저장할 리스트
  int selectedStation = 101; // 초기 선택된 station_ID
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Bulletin_Board테이블의 데이터를 가져옴
  CollectionReference product =
      FirebaseFirestore.instance.collection('Bulletin_Board');

  // 댓글을 저장할 서브컬렉션을 위한 참조 생성
  CollectionReference commentsReference(String postId) {
    return product.doc(postId).collection('comments');
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController stationController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  // 게시물 편집
  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    titleController.text = documentSnapshot['title'];
    contentController.text = documentSnapshot['content'];
    stationController.text = documentSnapshot['station_ID'].toString();

    // 이 부분에서 현재 사용자의 정보를 가져옴
    User? currentUser = _auth.currentUser;
    String? currentUserId = currentUser?.uid;

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
                ElevatedButton(
                  onPressed: () async {
                    final String title = titleController.text;
                    final String content = contentController.text;
                    final int station =
                        int.tryParse(stationController.text) ?? 0;

                    await product.doc(documentSnapshot.id).update(
                      {
                        "title": title,
                        "content": content,
                        "station_ID": station,
                        "updated_at": FieldValue.serverTimestamp(),
                        "User_ID": currentUserId,
                      },
                    );

                    titleController.text = "";
                    contentController.text = "";
                    stationController.text = "";
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

  //게시글 생성
  Future<void> _create() async {
    // 이 부분에서 현재 사용자의 정보를 가져옴
    User? currentUser = _auth.currentUser;
    String? currentUserId = currentUser?.uid;

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
                ElevatedButton(
                  onPressed: () async {
                    final String title = titleController.text;
                    final String content = contentController.text;
                    final int station =
                        int.tryParse(stationController.text) ?? 0;

                    await product.add({
                      'title': title,
                      'content': content,
                      'station_ID': station,
                      'created_at': FieldValue.serverTimestamp(),
                      'User_ID': currentUserId,
                    });

                    titleController.text = "";
                    contentController.text = "";
                    stationController.text = "";
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

  //게시글 삭제
  Future<void> _delete(String productId) async {
    await product.doc(productId).delete();
  }

  @override
  void initState() {
    super.initState();
    fetchStationIds(); // initState에서 station_ID 목록을 가져오도록 설정
  }

  // Firestore에서 station_ID 목록을 가져오는 메서드
  Future<void> fetchStationIds() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Bulletin_Board').get();

    List<int> ids = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in snapshot.docs) {
      int stationId = document.data()['station_ID'];
      if (!ids.contains(stationId)) {
        ids.add(stationId);
      }
    }

    setState(() {
      stationIds = ids;
    });
  }

// 댓글 목록을 가져와 표시하는 위젯
  Widget buildCommentsSection(String postId) {
    return StreamBuilder(
      stream: commentsReference(postId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('댓글', style: TextStyle(fontWeight: FontWeight.bold)),
              // 댓글 목록을 출력하는 방법 구현
              // snapshot.data.docs를 사용하여 댓글 목록을 가져올 수 있습니다.
              // 댓글 내용, 작성자 등을 표시할 수 있습니다.
              // 각 댓글에 대한 삭제 기능 등도 추가 가능
              for (QueryDocumentSnapshot<Map<String, dynamic>> commentSnapshot
                  in snapshot.data!.docs
                      .cast<QueryDocumentSnapshot<Map<String, dynamic>>>())
                ListTile(
                  title: Text('작성자: ${commentSnapshot['user']}'),
                  // 추가적인 정보나 삭제 기능을 표시하려면 여기에 추가
                ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

// 댓글을 작성하는 입력 필드와 버튼을 표시하는 위젯
  Widget buildCommentInputField(String postId) {
    TextEditingController commentController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: '댓글을 입력하세요',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final String commentText = commentController.text;
            if (commentText.isNotEmpty) {
              // 댓글을 Firestore에 추가
              await commentsReference(postId).add({
                'text': commentText,
                'user': '사용자', // 사용자 ID 또는 다른 사용자 정보 추가 가능
                'timestamp': FieldValue.serverTimestamp(),
              });

              // 댓글 입력 필드 초기화
              commentController.clear();
            }
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.deepPurple),
          ),
          child: const Text('댓글 추가'),
        ),
      ],
    );
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<int>(
              value: selectedStation,
              items: stationIds.map((int stationId) {
                return DropdownMenuItem<int>(
                  value: stationId,
                  child: Text('$stationId호'),
                );
              }).toList(),
              onChanged: (int? value) {
                if (value != null) {
                  setState(() {
                    selectedStation = value;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: product
                  .where('station_ID', isEqualTo: selectedStation)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      DateTime createdAt;
                      if (documentSnapshot['created_at'] != null) {
                        createdAt =
                            (documentSnapshot['created_at'] as Timestamp)
                                .toDate();
                      } else {
                        createdAt = DateTime.now();
                      }

                      String formattedDate =
                          DateFormat('yyyy년-MM월-dd일 a h시 mm분', 'ko_KR')
                              .format(createdAt);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommentPage(postSnapshot: documentSnapshot),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5),
                              ListTile(
                                title: Text(
                                  documentSnapshot['title'],
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 5.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        documentSnapshot['content'],
                                      ),
                                      FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(documentSnapshot['User_ID'])
                                            .get(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                userSnapshot) {
                                          if (userSnapshot.hasData &&
                                              userSnapshot.data != null &&
                                              userSnapshot.data!.exists) {
                                            // Users 테이블에서 해당 사용자의 닉네임 가져오기
                                            Map<String, dynamic> userData =
                                                userSnapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            String nickname =
                                                userData['nickname'];
                                            // 닉네임으로 사용자 구분
                                            return Text('사용자: $nickname');
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                      Text(
                                        '작성일: $formattedDate',
                                      ),
                                    ],
                                  ),
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
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      // 글 작성 버튼
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[300],
        onPressed: () {
          _create();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Text(
          '글 작성',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
