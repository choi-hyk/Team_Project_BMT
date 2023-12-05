import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StationBoardHome extends StatefulWidget {
  final Map<String, dynamic> bulletinData;

  const StationBoardHome({Key? key, required this.bulletinData})
      : super(key: key);

  @override
  State<StationBoardHome> createState() => _StationBoardHomeState();
}

class _StationBoardHomeState extends State<StationBoardHome> {
  late TextEditingController commentController;
  final ScrollController _commentScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    DateTime createdAt;
    if (widget.bulletinData['created_at'] != null) {
      createdAt = (widget.bulletinData['created_at'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now();
    }

    createdAt = createdAt.add(const Duration(hours: 9));

    String formattedDate =
        DateFormat('yyyy.MM.dd  hh :  mm', 'ko_KR').format(createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '게시글 상세 정보',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bulletinData['title'],
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.bulletinData['content'],
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(widget.bulletinData['User_ID'])
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.hasData &&
                            userSnapshot.data != null &&
                            userSnapshot.data!.exists) {
                          Map<String, dynamic> userData =
                              userSnapshot.data!.data() as Map<String, dynamic>;
                          String nickname = userData['nickname'];
                          return Text(
                            '작성자: $nickname',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    Text(
                      '작성일: $formattedDate',
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 1.0,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
