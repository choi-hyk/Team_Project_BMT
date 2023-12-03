import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test1/main.dart';
import 'package:test1/prov_reawrd.dart';

class ProvConf extends StatefulWidget {
  final String currentStaion;
  final String linkStaion;
  final int line;
  final String confg;

  const ProvConf({
    Key? key,
    required this.currentStaion,
    required this.linkStaion,
    required this.line,
    required this.confg,
  }) : super(key: key);

  @override
  State<ProvConf> createState() => ProvConfState();
}

class ProvConfState extends State<ProvConf> {
  int selectedIconIndex = -1;
  String currentTime = DateFormat('HH:mm').format(DateTime.now());
  int currentHour = DateTime.now().hour;
  int currentMinute = DateTime.now().minute;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCongestionData(int congestionLevel) async {
    try {
      // 데이터
      int station = int.parse(widget.currentStaion);
      int line = widget.line;
      int next = int.parse(widget.linkStaion);
      int hour = currentHour;
      int minute = getMinuteRange(currentMinute);

      // Firestore에 데이터 추가
      await _firestore.collection('Congestion').add({
        'station': station,
        'line': line,
        'next': next,
        'hour': hour,
        'minute': minute,
        'cong': congestionLevel,
      });

      print('Congestion data added successfully');
    } catch (e) {
      print('Error adding congestion data: $e');
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
          '혼잡도 정보 제공',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: perlinedata(widget.line),
                  ),
                  child: Center(
                    child: Text(
                      (widget.line).toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: perlinedata(widget.line),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Colors.white),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.currentStaion,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 190,
                      height: 30,
                      decoration: BoxDecoration(
                        color: perlinedata(widget.line),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.rightLong,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: perlinedata(widget.line),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Colors.white),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.linkStaion,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(currentTime),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 410,
                    child: Column(
                      children: [
                        const Text(
                          "현재 혼잡도",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 6.5,
                        ),
                        Container(
                          width: double.infinity,
                          height: 190,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).canvasColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                getIconForIndex(
                                  int.parse(widget.confg),
                                ),
                                color: getColorForIndex(
                                  int.parse(widget.confg),
                                ),
                                size: 60,
                              ),
                              const SizedBox(
                                height: 6.5,
                              ),
                              getConfText(
                                int.parse(widget.confg),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6.5,
                        ),
                        const Text(
                          "제공할 혼잡도 정보",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 6.5,
                        ),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Theme.of(context).canvasColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 0; i < 5; i++)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIconIndex = i;
                                    });
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      color: selectedIconIndex == i
                                          ? Theme.of(context)
                                              .primaryColorDark // 선택된 아이콘 주변 컨테이너의 색상 변경
                                          : Theme.of(context).canvasColor,
                                    ),
                                    child: Icon(
                                      getIconForIndex(
                                          i), // i에 따른 아이콘을 가져오는 함수 호출
                                      size: 40,
                                      color: getColorForIndex(
                                          i), // i에 따른 아이콘 색상 설정
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () {
                      if (selectedIconIndex != -1) {
                        addCongestionData(selectedIconIndex + 1);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProvReward(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Center(
                        child: Text(
                          "정보 제공하고 리워드 받기!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
