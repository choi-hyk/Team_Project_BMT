import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/main.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/Congestion/congestion.dart';
import 'package:test1/Route/route_search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

//역 검색, 즐겨찾기에 탭, 노선도 해당 역 탭 -> StationData위젯 빌드
//역 정보를 보여주는 클래스 코드
//역 정보를 firestore데이터 베이스로 가져와서 매개변수로 받아옴
class StationData extends StatefulWidget {
  final void Function(bool) updateIsBookmark;
  final List line; //호선 정보 예) 101역 1호선과 2호선 존재 -> line[0] = 1, line[1] = 2
  //201역 2호선만 존재 -> line[0] = 2, line[1]은 없음

  final String name; //역 이름

  //편의 시설 정보 -> 존재하면 true, 없으면 false
  final bool cStore; //편의점
  final bool nRoom; //수유실

  bool isBook; //즐겨찾기 설정 여부

  final List nName; //번호상 증가하는 역   예) 101역 -> 102역 nName[0] = 102 nName[1] = 201
  final List pName; //번호상 감소하는 역                     pName[0] = 123 pName[1]은 없음

  // ignore: prefer_const_constructors_in_immutables
  StationData({
    Key? key,
    required this.line,
    required this.name,
    required this.cStore,
    required this.nRoom,
    required this.isBook,
    required this.nName,
    required this.pName,
    required this.updateIsBookmark,
  }) : super(key: key);

  @override
  State<StationData> createState() => _StationDataState();
}

class _StationDataState extends State<StationData> {
  UserProvider userProvider = UserProvider();

  DateTime nowtime = DateTime.now();

  String currentTime = DateFormat('HH:mm').format(DateTime.now());
  int currentHour = DateTime.now().hour;
  int currentMinute = DateTime.now().minute;

  int congestionN = -1;
  int congestionP = -1;

  bool isRunTime = false;
  bool isLoading = true;

  //검색역 게시글 목록을 가져오는 객체 변수
  late Future<List<DocumentSnapshot>> bulletinBoardPosts;

  @override
  void initState() {
    super.initState();

    calculateIsRunTime();

    loadCongestionData(0).then((_) {
      // 데이터 로딩 완료 후 상태 변경
      setState(() {
        isLoading = false;
      });
    });

    bulletinBoardPosts = fetchBulletinBoardPosts();
  }

  // Firestore 쿼리를 사용하여 특정 역의 게시글 가져오는 메소드
  Future<List<DocumentSnapshot>> fetchBulletinBoardPosts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Bulletin_Board')
        .where('station_ID', isEqualTo: int.parse(widget.name))
        .get();

    return snapshot.docs;
  }

  // Firestore에서 사용자 닉네임 가져오는 비동기 함수
  Future<String?> getUserNickname(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    return userSnapshot['nickname'];
  }

  //즐겨찾기 아이콘(star) 탭 로직 구현
  void toggleBookmark() {
    setState(() {
      widget.updateIsBookmark(!widget.isBook);
    });
  }

  Future<void> loadCongestionData(int array) async {
    int congestionDataN =
        await getCongestionData(int.parse(widget.nName[array]));
    int congestionDataP =
        await getCongestionData(int.parse(widget.pName[array]));

    congestionN = congestionDataN;
    congestionP = congestionDataP;

    print(congestionDataN);
    print(congestionN);
    print(congestionP);
  }

  Future<int> getCongestionData(int link) async {
    int station = int.parse(widget.name);
    int next = link;
    int line = widget.line[current_trans];
    int hour = currentHour;
    int minute = getMinuteRange(currentMinute);

    CollectionReference congestionCollection =
        FirebaseFirestore.instance.collection('Congestion');

    QuerySnapshot snapshot = await congestionCollection
        .where('station', isEqualTo: station)
        .where('next', isEqualTo: next)
        .where('line', isEqualTo: line)
        .where('hour', isEqualTo: hour)
        .where('minute', isEqualTo: minute)
        .get();

    int totalCongestion = 0;
    int numberOfMatchingDocuments = snapshot.docs.length;

    if (numberOfMatchingDocuments > 0) {
      // 매칭되는 문서들의 cong 값 합산
      for (var doc in snapshot.docs) {
        totalCongestion += doc['cong'] as int;
      }

      print('일치하는 문서 수: $numberOfMatchingDocuments');
      print('총 혼잡도 값: $totalCongestion');

      return totalCongestion ~/ numberOfMatchingDocuments;
    } else {
      return -1;
    }
  }

  void calculateIsRunTime() {
    setState(() {
      isRunTime = currentHour < 22 && currentHour >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      width: 440.5,
      height: 723.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        current_trans = 0;
                        loadCongestionData(0);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: perlinedata(widget.line[0]),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      width: 50,
                      height: 25,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.line[0].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3.5,
                  ),
                  if (widget.line.length == 2)
                    InkWell(
                      onTap: () {
                        setState(() {
                          current_trans = 1;
                          loadCongestionData(1);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: perlinedata(widget.line[1]),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        width: 50,
                        height: 25,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.line[1].toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  widget.line.length == 2
                      ? const SizedBox(width: 90)
                      : const SizedBox(width: 140),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteSearch(
                            startStation: widget.name,
                            arrivStation: null,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 2.0,
                        ),
                      ),
                      width: 60,
                      height: 35,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          '출발',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 1.5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteSearch(
                            startStation: null,
                            arrivStation: widget.name,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 2.0,
                        ),
                      ),
                      width: 60,
                      height: 35,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "도착",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6.5,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (widget.isBook) {
                          toggleBookmark();
                          userProvider.removeBookmarkStation(widget.name);
                        } else {
                          toggleBookmark();
                          userProvider.addBookmarkStation(widget.name);
                        }
                      });
                    },
                    child: Icon(
                      widget.isBook ? Icons.star : Icons.star_border_outlined,
                      size: 35,
                      color: widget.isBook
                          ? const Color.fromARGB(255, 224, 210, 91)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 6,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: perlinedata(widget.line[current_trans]),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      width: 400,
                      height: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_left,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            Text(
                              widget.pName[current_trans],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 230,
                            ),
                            Text(
                              widget.nName[current_trans],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              size: 24.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: perlinedata(widget.line[current_trans]),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  width: 160,
                  height: 80,
                  child: const Align(
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  width: 120,
                  height: 50,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "혼잡도 정보",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Text(
              currentTime,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isRunTime) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.pName[current_trans] == "종점역") ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          width: 160,
                          height: 120,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "종점역입니다",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 175.1,
                          height: 46,
                        ),
                      ],
                    ),
                  ] else ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                          width: 160,
                          height: 120,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  getIconForIndex(
                                    congestionP,
                                  ),
                                  color: getColorForIndex(congestionP),
                                  size: 40,
                                ),
                                getConfText(congestionP),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Congestion(
                                  currentStaion: widget.name,
                                  linkStaion: widget.pName[current_trans],
                                  confg: congestionP.toString(),
                                  line: widget.line[current_trans],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Theme.of(context).canvasColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.pName[current_trans]}역 방면 혼잡도 정보 제공",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (widget.nName[current_trans] == "종점역") ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          width: 160,
                          height: 120,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "종점역입니다",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 175.1,
                          height: 46,
                        ),
                      ],
                    ),
                  ] else ...[
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                          width: 160,
                          height: 120,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  getIconForIndex(
                                    congestionN,
                                  ),
                                  color: getColorForIndex(congestionN),
                                  size: 40,
                                ),
                                getConfText(congestionN),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Congestion(
                                  currentStaion: widget.name,
                                  linkStaion: widget.nName[current_trans],
                                  confg: congestionN.toString(),
                                  line: widget.line[current_trans],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Theme.of(context).canvasColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.nName[current_trans]}역 방면 혼잡도 정보 제공",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Theme.of(context).primaryColor),
                child: const Center(
                  child: Text(
                    "지하철 운영 시간이 아닙니다.",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "시설정보",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    FontAwesomeIcons.toilet,
                    color: Theme.of(context).primaryColorDark,
                    size: 45.0,
                  ),
                  if (widget.cStore)
                    Icon(
                      FontAwesomeIcons.store,
                      color: Theme.of(context).primaryColorDark,
                      size: 45.0,
                    ),
                  if (widget.nRoom)
                    Icon(
                      FontAwesomeIcons.personBreastfeeding,
                      color: Theme.of(context).primaryColorDark,
                      size: 45.0,
                    ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "역 게시판",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: bulletinBoardPosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // 게시글을 나타내는 UI 작성
                    List<DocumentSnapshot>? posts = snapshot.data;
                    if (posts != null && posts.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: false, // 스크롤이 가능하도록 설정
                        physics:
                            const AlwaysScrollableScrollPhysics(), // 항상 스크롤 가능하도록 설정
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot post = posts[index];
                          // 각 게시글의 UI를 작성하는 코드를 추가
                          return FutureBuilder<String?>(
                            future: getUserNickname(post['User_ID']),
                            builder: (context, nicknameSnapshot) {
                              String nickname = nicknameSnapshot.data ?? "익명";

                              DateTime createdAt =
                                  (post['created_at'] as Timestamp).toDate();
                              createdAt =
                                  createdAt.add(const Duration(hours: 9));
                              String formattedCreatedAt =
                                  DateFormat('yyyy.MM.dd  hh : mm', 'ko_KR')
                                      .format(createdAt);

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColorDark, // 테두리 색상
                                            width: 0.5, // 테두리 두께
                                          ),
                                          color: Theme.of(context).canvasColor),
                                      child: ListTile(
                                        title: Text(
                                          post['title'],
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("작성자: $nickname"),
                                            Text("작성일: $formattedCreatedAt"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.5,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return const Text('해당 역에 작성된 게시글이 없습니다.');
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
