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
        title: Text(widget.category),
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
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        store['name'],
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        ' ${store['pay']}p',
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Image.network(
                          store['image_url'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1.0,
                    color: Colors.grey,
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
