import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test1/main.dart';

class ProvConf extends StatefulWidget {
  final String currentStaion;
  final String linkStaion;
  final String confg;
  final int line;

  const ProvConf(
      {super.key,
      required this.currentStaion,
      required this.linkStaion,
      required this.line,
      required this.confg});

  @override
  State<ProvConf> createState() => ProvConfState();
}

class ProvConfState extends State<ProvConf> {
  int selectedIconIndex = -1;
  String currentTime = DateFormat('HH:mm').format(DateTime.now());
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 23,
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
                        Text(widget.confg),
                        const SizedBox(
                          height: 180,
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
                                      _getIconForIndex(
                                          i), // i에 따른 아이콘을 가져오는 함수 호출
                                      size: 40,
                                      color: _getColorForIndex(
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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () {},
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
                          "정보 제공하고 리워드 받기",
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

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return FontAwesomeIcons.solidFaceLaughBeam;
      case 1:
        return FontAwesomeIcons.solidFaceSmile;
      case 2:
        return FontAwesomeIcons.solidFaceMeh;
      case 3:
        return FontAwesomeIcons.solidFaceFrown;
      case 4:
        return FontAwesomeIcons.solidFaceTired;
      default:
        return Icons.error;
    }
  }

  Color _getColorForIndex(int index) {
    switch (index) {
      case 0:
        return const Color.fromARGB(255, 244, 238, 54);
      case 1:
        return const Color.fromARGB(255, 244, 206, 54);
      case 2:
        return const Color.fromARGB(255, 244, 165, 54);
      case 3:
        return const Color.fromARGB(255, 244, 130, 54);
      case 4:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
