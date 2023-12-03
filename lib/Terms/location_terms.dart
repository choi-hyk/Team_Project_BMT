import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String> loadTerms() async {
  return await rootBundle.loadString('assets/terms/location_terms.txt');
}

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
        title: Text("위치정보 이용약관"),
      ),
      body: FutureBuilder<String>(
        future: loadTerms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //데이터가 로드되면 표시
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Text(
                snapshot.data ?? '내용을 불러오는 데 실패했습니다.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          } else {
            //데이터 로딩 중에는 로딩 인디케이터 표시
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
