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
          "제 1 조 (목적)\n"
          "본 약관은 BMT가 제공하는 사물위치정보 및 위치기반 서비스(이하, 위치정보 서비스)에 대해 회사와 서비스를 이용하는 이용자간의 권리·의무 및 책임사항, 기타 필요한 사항 규정을 목적으로 합니다.\n"
          "제 2 조 (이용약관의 효력 및 변경)\n"
          "①본 약관은 이용자가 본 약관에 동의하고 회사가 정한 절차에 따라 위치정보 서비스의 이용자로 등록됨으로써 효력이 발생합니다.\n"
          "②이용자가 본 약관의 “동의하기” 버튼을 클릭하였을 경우 본 약관의 내용을 모두 읽고 이를 충분히 이해하였으며, 그 적용에 동의한 것으로 봅니다.\n"
          "③회사는 위치정보 서비스의 변경사항을 반영하기 위한 목적 등으로 필요한 경우 관련 법령을 위배하지 않는 범위에서 본 약관을 수정할 수 있습니다.\n"
          "④약관이 변경되는 경우 회사는 변경사항을 그 적용일자 최소 15일 전에 서비스 공지사항을 통해 공지합니다.\n"
          "⑤회사가 전항에 따라 공지 또는 통지를 하면서 공지 또는 통지일로부터 개정약관 시행일 7일 후까지 거부의사를 표시하지 아니하면 승인한 것으로 본다는 뜻을 명확하게 고지하였음에도 이용자의 의사표시가 없는 경우에는 변경된 약관을 승인한 것으로 봅니다. 이용자가 개정약관에 동의하지 않을 경우 본 약관에 대한 동의를 철회할 수 있습니다.\n"
          "제 3 조 (약관 외 준칙)\n"
          "이 약관에 명시되지 않은 사항에 대해서는 위치 정보의 보호 및 이용 등에 관한 법률, 개인정보보호법, 정보보호 등에 관한 법률 등 관계법령 및 회사가 정한 지침 등의 규정에 따릅니다.\n"
          "제 4 조 (서비스의 내용)\n"
          "BMT는 위치정보사업자로부터 수집한 이용자의 위치정보를 이용하여 아래와 같은 위치정보 서비스를 제공합니다.\n"
          "①지하철 사용을 위한 위치 공유, 위치/지역에 따른 알림, 경로 안내\n"
          "제 5 조 (서비스 이용요금)\n"
          "회사가 제공하는 위치정보 서비스는 무료입니다.\n"
          "단, 무선 서비스 이용 시 발생하는 데이터 통신료는 별도이며, 이용자가 가입한 각 이동통신사의 정책에 따릅니다.\n",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
