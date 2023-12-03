import 'package:flutter/material.dart';
import 'package:test1/search_widgets/stationdata_UI.dart';

class StationDataPage extends StatefulWidget {
  final List line;
  final String name;
  final bool cStore;
  final bool nRoom;
  final bool isBkMk;
  final List nName;
  final List pName;
  final List nCong;
  final List pCong;
  const StationDataPage({
    super.key,
    required this.line,
    required this.name,
    required this.cStore,
    required this.nRoom,
    required this.nCong,
    required this.pCong,
    required this.nName,
    required this.pName,
    required this.isBkMk,
  });

  @override
  State<StationDataPage> createState() => _StationDataPageState();
}

class _StationDataPageState extends State<StationDataPage> {
  late bool isBkMk = false;

  @override
  void initState() {
    super.initState();
    isBkMk = widget.isBkMk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ), // 뒤로 가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼을 누르면 현재 화면에서 빠져나감
          },
        ),
        title: const Text(
          "역 정보",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: const [],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Positioned(
                bottom: 40,
                child: StationData(
                  name: widget.name,
                  nRoom: widget.nRoom,
                  cStore: widget.cStore,
                  isBkMk: isBkMk,
                  nCong: widget.nCong,
                  pCong: widget.pCong,
                  line: widget.line,
                  nName: widget.nName,
                  pName: widget.pName,
                  updateIsBookmark: (bool newValue) {
                    setState(() {
                      isBkMk = newValue;
                    });
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: SizedBox(
                  //광고배너 컨테이너
                  width: double.infinity,
                  height: 55.0,
                  child: Image.asset(
                    'assets/images/광고3.png',
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
