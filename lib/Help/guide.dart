import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Guide extends StatefulWidget {
  const Guide({super.key});

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showContentDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가이드 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Guide')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('오류가 발생했습니다.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title'] ?? '제목 없음'),
                onTap: () => _showContentDialog(
                    data['title'] ?? '제목 없음', data['content'] ?? '내용 없음'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}