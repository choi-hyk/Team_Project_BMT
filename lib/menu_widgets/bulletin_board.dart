import 'package:flutter/material.dart';

class BulletinBoardPage extends StatefulWidget {
  const BulletinBoardPage({super.key});

  @override
  State<BulletinBoardPage> createState() => _BulletinBoardPageState();
}

class _BulletinBoardPageState extends State<BulletinBoardPage> {
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
          '게시판',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
    );
  }
}
