import 'package:flutter/material.dart';

class Location_Terms extends StatefulWidget {
  const Location_Terms({super.key});

  @override
  State<Location_Terms> createState() => _Location_TermsState();
}

class _Location_TermsState extends State<Location_Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위치정보 이용약관'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '위치 정보를 사용해도 되겠습니까',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
