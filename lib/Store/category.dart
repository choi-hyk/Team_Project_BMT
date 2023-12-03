import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Store/before_buy.dart';

class Category extends StatefulWidget {
  final String category;

  const Category({super.key, required this.category});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
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

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //이미지를 탭하면 구매 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BeforeBuy(
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
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
