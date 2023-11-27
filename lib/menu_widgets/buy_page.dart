import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'package:test1/menu_widgets/gift_page.dart';

class BuyPage extends StatefulWidget {
  final String category;
  final String categoryname;
  final int pay;
  final String imageUrl;
  final String icon;
  final String name;
  final String giftUrl;

  const BuyPage({
    Key? key,
    required this.category,
    required this.categoryname,
    required this.pay,
    required this.imageUrl,
    required this.icon,
    required this.name,
    required this.giftUrl,
  }) : super(key: key);

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); //사용자 정보

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.imageUrl,
            width: 413.0,
            height: 285.0,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10.0,
            ),
            child: Text(
              ' ${widget.name}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              left: 10.0,
            ),
            child: Text(
              ' ${widget.pay}p',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  widget.icon,
                  width: 33.0,
                  height: 33.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  ' ${widget.categoryname}',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              '상품 정보',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 35.0,
            ),
            child: Text(
              '모바일 교환권',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              bottom: 15.0,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.more_time_sharp,
                ),
                Text(
                  '유효기간 365일',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  // 구매를 누르면 사용자의 포인트를 확인하여 기프트 페이지로 이동
                  int userPoints = int.parse(userProvider.point);

                  if (userPoints >= widget.pay) {
                    // 포인트가 상품 가격보다 충분하면 구매 처리
                    int newPoints = userPoints - widget.pay;

                    try {
                      // Firestore에 사용자의 포인트 업데이트
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userProvider.user!.uid)
                          .update({'point': newPoints});

                      // 여기에 구매 기록 저장 또는 다른 Firebase 코드 추가

                      // 기프트 페이지로 이동
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GiftPage(giftUrl: widget.giftUrl),
                        ),
                      );
                    } catch (e) {
                      print('포인트 차감 중 에러 발생: $e');
                      // 에러 처리 로직 추가
                    }
                  } else {
                    // 포인트 부족 메시지 또는 다른 처리 로직 추가
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('포인트가 부족하여 구매할 수 없습니다.'),
                        action: SnackBarAction(
                          label: '확인',
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(314.0, 45.0)),
                ),
                child: const Text(
                  '구매 하기',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
