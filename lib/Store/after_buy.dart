import 'package:flutter/material.dart';
import 'package:test1/Store/store.dart';

class AfterBuy extends StatefulWidget {
  final String giftUrl;

  const AfterBuy({Key? key, required this.giftUrl}) : super(key: key);

  @override
  State<AfterBuy> createState() => _AfterBuyState();
}

class _AfterBuyState extends State<AfterBuy> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StorePage()),
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StorePage(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                widget.giftUrl,
                width: 350.0,
                height: 600.0,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20.0),
              const Text(
                '교환권 저장',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              const Text(
                '사용 가능한 매장을 확인해주세요',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
