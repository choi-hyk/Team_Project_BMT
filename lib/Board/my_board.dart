import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Provider/user_provider.dart';

class MyPost extends StatefulWidget {
  const MyPost({super.key});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  late Future<List<Map<String, dynamic>>> _writtenPosts;

  @override
  void initState() {
    super.initState();
    _writtenPosts = _fetchWrittenPosts();
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
          '내가 작성한 글',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _writtenPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('작성한 글이 없습니다.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Column(
                  children: [
                    ListTile(
                      tileColor: Colors.white,
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(
                        post['title'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post['content']),
                          const SizedBox(height: 8.0),
                          Text(
                            '작성 시간: ${_formatTimestamp(post['created_at'])}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchWrittenPosts() async {
    // Use UserProvider to get the written posts
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      return await userProvider.getWrittenPosts();
    } catch (e) {
      // Handle errors, such as displaying an error message
      print('Error fetching written posts: $e');
      return [];
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final adjustedDateTime = dateTime.add(const Duration(hours: 9));
    final formattedDate =
        DateFormat('yyyy년-MM월-dd일 a h시 mm분', 'ko_KR').format(adjustedDateTime);
    return formattedDate;
  }
}
