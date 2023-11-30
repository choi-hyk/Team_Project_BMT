import 'package:flutter/material.dart';
import 'package:test1/search_widgets/stationdata_UI.dart';

class StationDataPage extends StatefulWidget {
  final List line;
  final String name;
  final bool cStore;
  final bool nRoom;
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
  });

  @override
  State<StationDataPage> createState() => _StationDataPageState();
}

class _StationDataPageState extends State<StationDataPage> {
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
      body: StationData(
        name: widget.name,
        nRoom: widget.nRoom,
        cStore: widget.cStore,
        nCong: widget.nCong,
        pCong: widget.pCong,
        line: widget.line,
        nName: widget.nName,
        pName: widget.pName,
      ),
    );
  }
}
