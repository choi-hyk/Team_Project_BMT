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
          '1. 개인정보의 처리 목적\n'
          "<BMT>('Best Move for Transfortation') 는 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용하지 않습니다.\n"
          "고객 가입의사 확인, 고객에 대한 서비스 제공에 따른 본인 식별.인증, 회원자격 유지.관리\n"
          "2. 개인정보의 처리 및 보유 기간\n"
          "① 'BMT'는 정보주체로부터 개인정보를 수집할 때 동의 받은 개인정보 보유․이용기간 또는 법령에 따른 개인정보 보유․이용기간 내에서 개인정보를 처리․보유합니다.\n"
          "② 구체적인 개인정보 처리 및 보유 기간은 다음과 같습니다.\n"
          "- 고객 가입 및 관리 : 이메일을 사용한 회원가입 및 관리\n"
          "- 보유 기간 : BMT 탈퇴 시, 즉시 삭제\n"
          "3. 정보주체와 법정대리인의 권리·의무 및 그 행사방법 이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.\n"
          "① 정보주체는 'BMT' 에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.\n"
          "1. 개인정보 열람요구\n"
          "2. 오류 등이 있을 경우 정정 요구\n"
          "3. 삭제요구\n"
          "4. 처리정지 요구\n"
          "4. 처리하는 개인정보의 항목 작성\n"
          "① 'BTM'는 다음의 개인정보 항목을 처리하고 있습니다.\n"
          "<'BTM'에서 수집하는 개인정보 항목>\n"
          "'BTM' 회원 가입 시, 제공 동의를 해주시는 개인정보 수집 항목입니다.\n"
          "■ 회원 가입 시\n"
          " - 필수항목 : 이름, 이메일, 전화번호, 연령대\n"
          " - 수집목적 : BMT 회원관리 및 마케팅 이용\n"
          " - 보유기간 : 회원 탈퇴 또는 동의철회 시 지체없이 파기\n",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
