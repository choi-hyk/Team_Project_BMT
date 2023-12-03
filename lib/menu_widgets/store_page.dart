import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/interface.dart';
import 'package:test1/main.dart';
// import 'package:provider/provider.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'package:test1/menu_widgets/buy_page.dart';
import 'package:test1/menu_widgets/category_page.dart';

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
          color: Colors.white,
        ),
        width: 70,
        height: 33,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            categoryName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
          MaterialPageRoute(builder: (context) => const InterFace()),
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              currentUI = "home";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const InterFace(),
                ),
              );
            },
          ),
          title: const Text(
            '스토어',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
                      width: 80.0,
                    ),
                    // 리워드 포인트
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
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
                                height: 120,
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
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                                  subtitle: Text(
                                    ' ${store['pay']}p',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                                  leading: SizedBox(
                                    width: 100,
                                    height: 120,
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
              ),
              SizedBox(
                width: double.infinity,
                height: 60.0,
                child: Image.asset(
                  'assets/images/광고2.png',
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
