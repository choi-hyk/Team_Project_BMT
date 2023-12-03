import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class LostBoard extends StatefulWidget {
  final DocumentSnapshot postSnapshot;

  const LostBoard({Key? key, required this.postSnapshot}) : super(key: key);

  @override
  State<LostBoard> createState() => _LostCommentPageState();
}

class _LostCommentPageState extends State<LostBoard> {
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot postSnapshot = widget.postSnapshot;

    DateTime createdAt;
    if (postSnapshot['created_at'] != null) {
      createdAt = (postSnapshot['created_at'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now();
    }

    //에뮬레이터 시간상 한국 시간과 안맞음. 9시간 추가
    createdAt = createdAt.add(const Duration(hours: 9));

    String formattedDate =
        DateFormat('yyyy년-MM월-dd일 a h시 mm분', 'ko_KR').format(createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시물 상세 정보'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postSnapshot['title'],
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              postSnapshot['content'],
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            //게시글 작성자 정보 가져오기
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(postSnapshot['User_ID'])
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                if (userSnapshot.hasData &&
                    userSnapshot.data != null &&
                    userSnapshot.data!.exists) {
                  //게시글 작성자의 닉네임 가져오기
                  String? nickname = userSnapshot.data!['nickname'];
                  return Text(
                    '작성자: ${nickname ?? '사용자'}',
                    style: const TextStyle(fontSize: 16.0),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              '작성일: $formattedDate',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            const Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            const Text(
              '댓글',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            //댓글 목록을 표시하는 부분
            buildCommentsSection(postSnapshot.id),
            //댓글 입력 필드 및 추가 버튼
            buildCommentInputField(postSnapshot.id),
          ],
        ),
      ),
    );
  }

  //댓글 관련 위젯
  Widget buildCommentsSection(String postId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('LostAndFound')
          .doc(postId)
          .collection('comments')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (QueryDocumentSnapshot<Map<String, dynamic>> commentSnapshot
                  in snapshot.data!.docs
                      .cast<QueryDocumentSnapshot<Map<String, dynamic>>>())
                //댓글 작성자 정보 가져오기
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(commentSnapshot['user'])
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.hasData &&
                        userSnapshot.data != null &&
                        userSnapshot.data!.exists) {
                      //댓글 작성자의 닉네임 가져오기
                      String? nickname = userSnapshot.data!['nickname'];
                      return ListTile(
                        title: Text(commentSnapshot['text']),
                        subtitle: Text('작성자: ${nickname ?? '사용자'}'),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  //댓글 작성 위젯
  Widget buildCommentInputField(String postId) {
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
              // 현재 사용자 정보 가져오기
              User? currentUser = FirebaseAuth.instance.currentUser;
              String? currentUserNickname = currentUser?.displayName;

              // 댓글을 Firestore에 추가
              await FirebaseFirestore.instance
                  .collection('LostAndFound')
                  .doc(postId)
                  .collection('comments')
                  .add({
                'text': commentText,
                'user': currentUser?.uid, // 사용자 ID 또는 다른 사용자 정보 추가 가능
                'timestamp': FieldValue.serverTimestamp(),
              });

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
}
