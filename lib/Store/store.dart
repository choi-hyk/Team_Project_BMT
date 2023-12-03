import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Provider/user_provider.dart';
import 'package:test1/main.dart';
import 'package:test1/Interface/menu.dart';
import 'package:test1/Store/before_buy.dart';
import 'package:test1/Store/category.dart';
// import 'package:provider/provider.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  UserProvider userProvider = UserProvider();
  void showCategoryList(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(category: category),
      ),
    );
  }

  Widget buildCategoryContainer(String categoryName, Function(String) onTap) {
    return GestureDetector(
      onTap: () => onTap(categoryName),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          color: Colors.white,
        ),
        width: 70,
        height: 33,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            categoryName,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark),
          ),
        ),
      ),
    );
  }

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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        currentUI = 'home';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ), // 뒤로 가기 아이콘
            onPressed: () {
              Navigator.pop(context);
              currentUI = "home";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Menu(),
                ),
              );
            },
          ),
          title: const Text(
            '스토어',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
        ),
        body: Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 6.5,
                    ),
                    buildCategoryContainer("편의점", showCategoryList),
                    const SizedBox(
                      width: 6.5,
                    ),
                    buildCategoryContainer("카페", showCategoryList),
                    const SizedBox(
                      width: 6.5,
                    ),
                    buildCategoryContainer("상품권", showCategoryList),
                    const SizedBox(
                      width: 100.0,
                    ),
                    // 리워드 포인트
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                          color: Colors.deepPurple[200],
                        ),
                        width: 60,
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${userProvider.point}p",
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6.5,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Store')
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
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
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
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                    subtitle: Text(
                                      ' ${store['pay']}p',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
