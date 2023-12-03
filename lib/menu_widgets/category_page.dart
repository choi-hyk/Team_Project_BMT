import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/menu_widgets/buy_page.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Store')
            .where('category', isEqualTo: widget.category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var stores = snapshot.data!.docs;

          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              var store = stores[index].data();

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // 이미지를 탭하면 구매 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyPage(
                            category: store['category'],
                            categoryname: store['category_name'],
                            icon: store['icon'],
                            imageUrl: store['image_url'],
                            name: store['name'],
                            pay: store['pay'],
                            giftUrl: store['gift_url'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          store['name'],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        subtitle: Text(
                          ' ${store['pay']}p',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        leading: SizedBox(
                          width: 90,
                          height: 130,
                          child: Image.network(
                            store['image_url'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
