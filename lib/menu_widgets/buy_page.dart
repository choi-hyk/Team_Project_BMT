import 'package:flutter/material.dart';

class BuyPage extends StatefulWidget {
  final String category;
  final String categoryname;
  final int pay;
  final String imageUrl;
  final String icon;
  final String name;

  const BuyPage({
    Key? key,
    required this.category,
    required this.categoryname,
    required this.pay,
    required this.imageUrl,
    required this.icon,
    required this.name,
  }) : super(key: key);

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  //
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
