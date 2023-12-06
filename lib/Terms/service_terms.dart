import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String> loadTerms() async {
  return await rootBundle.loadString('assets/terms/service_terms.txt');
}

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('서비스 이용 약관',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: loadTerms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //데이터가 로드되면 표시
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                snapshot.data ?? '내용을 불러오는 데 실패했습니다.',
                style: const TextStyle(fontSize: 16.0),
              ),
            );
          } else {
            //데이터 로딩 중에는 로딩 인디케이터 표시
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
