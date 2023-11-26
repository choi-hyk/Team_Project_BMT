import 'package:flutter/material.dart';

class Privacy_Terms extends StatefulWidget {
  const Privacy_Terms({super.key});

  @override
  State<Privacy_Terms> createState() => _Privacy_TermsState();
}

class _Privacy_TermsState extends State<Privacy_Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인 정보 처리 방침'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '개인 정보 사용에 동의하십니까',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
