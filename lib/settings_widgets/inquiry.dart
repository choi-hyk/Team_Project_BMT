import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:test1/settings_widgets/inquiry_comment_page.dart';

class Inquiry extends StatefulWidget {
  const Inquiry({super.key});

  @override
  State<Inquiry> createState() => _InquiryState();
}

class _InquiryState extends State<Inquiry> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Inquiry 테이블의 데이터를 가져옴
  CollectionReference product =
      FirebaseFirestore.instance.collection('Inquiry');

  // 댓글을 저장할 서브컬렉션을 위한 참조 생성
  CollectionReference commentsReference(String postId) {
    return product.doc(postId).collection('comments');
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // 게시물 편집
  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    // 이 부분에서 현재 사용자의 정보를 가져옴
    User? currentUser = _auth.currentUser;
    String? currentUserId = currentUser?.uid;

    // 게시글 작성자와 현재 로그인한 사용자가 동일한지 확인
    if (documentSnapshot['User_ID'] == currentUserId) {
      titleController.text = documentSnapshot['title'];
      contentController.text = documentSnapshot['content'];

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
                  ElevatedButton(
                    onPressed: () async {
                      final String title = titleController.text;
                      final String content = contentController.text;

                      await product.doc(documentSnapshot.id).update(
                        {
                          "title": title,
                          "content": content,
                          "date": FieldValue.serverTimestamp(),
                          "User_ID": currentUserId,
                        },
                      );

                      titleController.text = "";
                      contentController.text = "";
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
    } else {
      // 작성자가 아닌 경우 수정 권한이 없음을 알림
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('권한 없음'),
          content: const Text('자신이 작성한 게시글만 수정할 수 있습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
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
                ElevatedButton(
                  onPressed: () async {
                    final String title = titleController.text;
                    final String content = contentController.text;

                    await product.add({
                      'title': title,
                      'content': content,
                      'date': FieldValue.serverTimestamp(),
                      'User_ID': currentUserId,
                    });

                    titleController.text = "";
                    contentController.text = "";
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
    // 현재 사용자의 정보를 가져옴
    User? currentUser = _auth.currentUser;
    String? currentUserId = currentUser?.uid;

    // 게시글 작성자와 현재 로그인한 사용자가 동일한지 확인
    DocumentSnapshot documentSnapshot = await product.doc(productId).get();

    if (documentSnapshot['User_ID'] == currentUserId) {
      await product.doc(productId).delete();
    } else {
      // 작성자가 아닌 경우 삭제 권한이 없음을 알림
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('권한 없음'),
          content: const Text('자신이 작성한 게시글만 삭제할 수 있습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
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
        title: const Text(
          '문의하기',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: product.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                DateTime date;
                if (documentSnapshot['date'] != null) {
                  date = (documentSnapshot['date'] as Timestamp).toDate();
                } else {
                  date = DateTime.now();
                }

                //에뮬레이터 시간상 한국 시간과 안맞음. 9시간 추가
                date = date.add(const Duration(hours: 9));

                String formattedDate =
                    DateFormat('yyyy년-MM월-dd일 a h시 mm분', 'ko_KR').format(date);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InquiryCommentPage(postSnapshot: documentSnapshot),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      String nickname = userData['nickname'];
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
