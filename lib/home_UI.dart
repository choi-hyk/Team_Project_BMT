import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test1/provider_code/user_provider.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  UserProvider userProvider = UserProvider();
  int selectedStation = 101;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(13.0),
          topRight: Radius.circular(13.0),
        ),
        border: Border.all(
          color: Colors.grey, // 테두리 색상
          width: 1.5, // 테두리 두께
        ),
      ),
      width: 379.5,
      height: 640.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
              width: 50,
              height: 10,
            ),
            const SizedBox(
              height: 35,
            ),
            const Divider(
              height: 1, // 구분선의 높이
              thickness: 1, // 구분선의 두께
              color: Colors.grey, // 구분선의 색상
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("즐겨찾기"),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: userProvider.getBookmarkList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('에러: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('즐겨찾기가 없습니다.'));
                  } else {
                    List<Widget> bookmarkWidgets = snapshot.data!.map((item) {
                      if (item['type'] == 'station') {
                        return buildStationBookmark(item['data']);
                      } else {
                        return buildRouteBookmark(item['data']);
                      }
                    }).toList();

                    return ListView(
                      children: bookmarkWidgets,
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 1, // 구분선의 높이
              thickness: 1, // 구분선의 두께
              color: Colors.grey, // 구분선의 색상
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('게시판'),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Bulletin_Board')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return buildBulletinPost(
                            documentSnapshot.data() as Map<String, dynamic>);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 역 즐겨찾기 위젯 생성
  Widget buildStationBookmark(String station) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey, // 테두리 색상
              width: 1, // 테두리 두께
            ),
          ),
          width: double.infinity,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 90,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    station,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                width: 90,
              ),
              const SizedBox(
                width: 90,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // 경로 즐겨찾기 위젯 생성
  Widget buildRouteBookmark(Map<String, dynamic> data) {
    final String station1 = data['station1_ID'];
    final String station2 = data['station2_ID'];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey, // 테두리 색상
              width: 1, // 테두리 두께
            ),
          ),
          width: double.infinity,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 90,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    station1,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                width: 90,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: 90,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    station2,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // 게시글 가져오기
  Widget buildBulletinPost(Map<String, dynamic> data) {
    DateTime createdAt;
    if (data['created_at'] != null) {
      createdAt = (data['created_at'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now();
    }

    createdAt = createdAt.add(const Duration(hours: 9));

    String formattedDate =
        DateFormat('yyyy년-MM월-dd일 a h시 mm분', 'ko_KR').format(createdAt);

    return GestureDetector(
      onTap: () {
        //
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
                data['title'],
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
                      data['content'],
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(data['User_ID'])
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.hasData &&
                            userSnapshot.data != null &&
                            userSnapshot.data!.exists) {
                          Map<String, dynamic> userData =
                              userSnapshot.data!.data() as Map<String, dynamic>;
                          String nickname = userData['nickname'];
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
  }
}
