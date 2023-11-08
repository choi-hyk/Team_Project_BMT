import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  void getData() async {}

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: getData,
        child: const Text('Get Data'),
      ),
    );
  }

  void getData() async {
    final stationData = await firestore
        .collection('Sections')
        .doc('07Qzp2VopiTvYILB7vHT')
        .get();

    print(stationData.data());
  }
}
