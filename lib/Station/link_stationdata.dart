import 'package:flutter/material.dart';
import 'package:test1/main.dart';
import 'package:test1/Interface/menu.dart';
import 'package:test1/Station/stationdata.dart';

class LinkStationData extends StatefulWidget {
  final List line;
  final String name;
  final bool cStore;
  final bool nRoom;
  final bool isBkMk;
  final List nName;
  final List pName;
  final int nCong;
  final int pCong;
  final bool check;

  const LinkStationData({
    Key? key,
    required this.line,
    required this.name,
    required this.cStore,
    required this.nRoom,
    required this.nName,
    required this.pName,
    required this.isBkMk,
    required this.check,
    required this.nCong,
    required this.pCong,
  }) : super(key: key);

  @override
  State<LinkStationData> createState() => _LinkStationDataState();
}

class _LinkStationDataState extends State<LinkStationData> {
  late bool isBkMk = false;

  @override
  void initState() {
    super.initState();
    isBkMk = widget.isBkMk;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        if (widget.check == true) {
          return true;
        } else {
          currentUI = 'home';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Menu()),
          );
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              if (widget.check == true) {
              } else {
                currentUI = 'home';
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Menu()),
                );
              }
            },
          ),
          title: const Text(
            "역 정보",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StationData(
                name: widget.name,
                nRoom: widget.nRoom,
                cStore: widget.cStore,
                isBook: isBkMk,
                line: widget.line,
                nName: widget.nName,
                pName: widget.pName,
                nCong: widget.nCong,
                pCong: widget.pCong,
                updateIsBookmark: (bool newValue) {
                  setState(() {
                    isBkMk = newValue;
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 55.0,
              child: Image.asset(
                'assets/images/광고3.png',
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
