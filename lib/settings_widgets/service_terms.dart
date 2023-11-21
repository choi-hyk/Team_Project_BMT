import 'package:flutter/material.dart';

class Service_Terms extends StatefulWidget {
  const Service_Terms({super.key});

  @override
  State<Service_Terms> createState() => _Service_TermsState();
}

class _Service_TermsState extends State<Service_Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('서비스 이용약관'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '제 1조 목적 어쩌구 저쩌구..',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
