import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Provider/data_provider.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/Route/route_result.dart';
import 'package:test1/Station/link_stationdata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

//메인메뉴의 디폴트 화면
//즐겨찾기 메뉴와 사용자 설정 역 게시파나 보여줌
class Home extends StatefulWidget {
  final String mainStation;

  const Home({
    super.key,
    required this.mainStation,
  });
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //프로바이더 객체 선언
  DataProvider dataProvider = DataProvider();
  UserProvider userProvider = UserProvider();

  //사용자가 즐겨찾기 탭할경우 stationdata빌드
  Future<void> returnStationData(String station) async {
    await dataProvider.searchData(int.parse(station));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LinkStationData(
          name: dataProvider.name,
          nRoom: dataProvider.nRoom,
          cStore: dataProvider.cStore,
          isBkMk: dataProvider.isBkmk,
          line: dataProvider.line,
          nName: dataProvider.nName,
          pName: dataProvider.pName,
          nCong: dataProvider.nCong,
          pCong: dataProvider.pCong,
          check: false,
        ),
      ),
    );
  }

  //역 즐겨찾기 위젯
  Widget buildStationBookmark(String station) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              returnStationData(station);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).primaryColorDark, // 테두리 색상
                width: 0.5, // 테두리 두께
              ),
            ),
            width: double.infinity,
            height: 100,
            child: Center(
              child: Text(
                "$station Station",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  //경로 즐겨찾기 위젯
  Widget buildRouteBookmark(Map<String, dynamic> data) {
    final String station1 = data['station1_ID'];
    final String station2 = data['station2_ID'];

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RouteResults(
                  startStation: station1,
                  arrivStation: station2,
                  check: false,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).primaryColorDark, // 테두리 색상
                width: 0.5, // 테두리 두께
              ),
            ),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "$station1 Station",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesomeIcons.rightLong,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "$station2 Station",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  //게시글 위젯
  Widget buildBulletinPost(Map<String, dynamic> data) {
    DateTime createdAt;
    if (data['created_at'] != null) {
      createdAt = (data['created_at'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now();
    }

    createdAt = createdAt.add(const Duration(hours: 9));

    String formattedDate =
        DateFormat('yyyy.MM.dd  hh :  mm', 'ko_KR').format(createdAt);

    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(
                  color: Theme.of(context).primaryColorDark, // 테두리 색상
                  width: 0.5, // 테두리 두께
                ),
              ),
              child: ListTile(
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
                            Map<String, dynamic> userData = userSnapshot.data!
                                .data() as Map<String, dynamic>;
                            String nickname = userData['nickname'];
                            return Text('작성자: $nickname');
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
            ),
          ],
        ),
      ),
    );
  }

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
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      width: 379.5,
      height: 723.0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Theme.of(context).canvasColor),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/Fast1.png",
                          fit: BoxFit.contain,
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Fast UI!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).cardColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              height: 0.5, //구분선의 높이
              thickness: 0.5, //구분선의 두께
              color: Theme.of(context).primaryColorDark, //구분선의 색상
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "즐겨찾기",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark),
            ),
            const SizedBox(
              height: 4.3,
            ),
            //즐겨찾기 스크롤 메뉴
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
            Divider(
              height: 0.5,
              thickness: 0.5,
              color: Theme.of(context).primaryColorDark,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${widget.mainStation}역 게시판',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark),
            ),
            const SizedBox(
              height: 4.3,
            ),

            //게시판 스크롤 메뉴
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: userProvider.getBulletinPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('에러: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('해당 역의 게시글이 없습니다'));
                  } else {
                    return ListView(
                      children: snapshot.data!.map((doc) {
                        return buildBulletinPost(doc);
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //역 즐겨찾기 위젯 생성
}
