import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/Store/after_buy.dart';

class BeforeBuy extends StatefulWidget {
  final String category;
  final String categoryname;
  final int pay;
  final String imageUrl;
  final String icon;
  final String name;
  final String giftUrl;

  const BeforeBuy({
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
  State<BeforeBuy> createState() => _BeforeBuyState();
}

class _BeforeBuyState extends State<BeforeBuy> {
  UserProvider userProvider = UserProvider();
  @override
  void initState() {
    super.initState();
    updateUserProviderData();
  }

  Future<void> updateUserProviderData() async {
    await userProvider.fetchUserInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "상품 정보",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(6.5),
                    bottomRight: Radius.circular(6.5)),
                color: Theme.of(context).canvasColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 410.0,
                  height: 285.0,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
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
                top: 20.0,
                left: 10.0,
              ),
              child: Text(
                ' ${widget.pay}p',
                style: const TextStyle(
                  fontSize: 17.0,
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
                  fontSize: 14.0,
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
                  fontSize: 13.0,
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
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    int userPoints = int.parse(userProvider.point);

                    if (userPoints >= widget.pay) {
                      int newPoints = userPoints - widget.pay;

                      try {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(userProvider.user!.uid)
                            .update({'point': newPoints});

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AfterBuy(giftUrl: widget.giftUrl),
                          ),
                        );
                      } catch (e) {
                        print('포인트 차감 중 에러 발생: $e');
                        //에러 처리 로직 추가
                      }
                    } else {
                      //포인트 부족 메시지 또는 다른 처리 로직 추가
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
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    fixedSize: MaterialStateProperty.all<Size>(
                        const Size(314.0, 45.0)),
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
            Container(
              width: double.infinity,
              height: 119,
              color: Theme.of(context).primaryColorLight,
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/Fast1.png",
                    fit: BoxFit.contain,
                    width: 150,
                    height: 200,
                  ),
                  Text(
                    "혼잡도 정보 제공하고 리워드 받자!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).cardColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
