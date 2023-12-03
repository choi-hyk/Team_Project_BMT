import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Inquiry extends StatefulWidget {
  final DocumentSnapshot postSnapshot;

  const Inquiry({Key? key, required this.postSnapshot}) : super(key: key);

  @override
  State<Inquiry> createState() => InquiryState();
}

class InquiryState extends State<Inquiry> {
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

    createdAt = createdAt.add(const Duration(hours: 9));

    String formattedDate =
        DateFormat('yyyy년-MM월-dd일 a h시 mm분', 'ko_KR').format(createdAt);

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
              '답글',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            //답글 목록을 표시하는 부분
            buildCommentsSection(postSnapshot.id),
          ],
        ),
      ),
    );
  }

  //문의 답글 위젯
  Widget buildCommentsSection(String postId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Inquiry')
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
                  subtitle: Text('${commentSnapshot['admin'] ?? 'Unknown'}'),
                ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
