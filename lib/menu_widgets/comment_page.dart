import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentPage extends StatefulWidget {
  final DocumentSnapshot postSnapshot;

  const CommentPage({Key? key, required this.postSnapshot}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
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
            Text(
              '작성자: ${postSnapshot['User_ID']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            Text(
              '작성일: $formattedDate',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            const Text(
              '댓글',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            // 댓글 목록을 표시하는 부분
            buildCommentsSection(postSnapshot.id),
            // 댓글 입력 필드 및 추가 버튼
            buildCommentInputField(postSnapshot.id),
          ],
        ),
      ),
    );
  }

  Widget buildCommentsSection(String postId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Bulletin_Board')
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
                ListTile(
                  title: Text(commentSnapshot['text']),
                  subtitle: Text('작성자: ${commentSnapshot['user']}'),
                ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

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
              await FirebaseFirestore.instance
                  .collection('Bulletin_Board')
                  .doc(postId)
                  .collection('comments')
                  .add({
                'text': commentText,
                'user': '사용자', // 사용자 ID 또는 다른 사용자 정보 추가 가능
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
