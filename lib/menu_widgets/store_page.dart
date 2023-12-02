import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:test1/provider_code/user_provider.dart';
import 'package:test1/menu_widgets/buy_page.dart';
import 'package:test1/menu_widgets/category_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool _isSearching = false;
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ), // 뒤로 가기 아이콘
          onPressed: () {
            _isSearching = false;
            Navigator.pop(context); // 뒤로 가기 버튼을 누르면 현재 화면에서 빠져나감
          },
        ),
        title: _isSearching
            ? TextField(
                // 검색 모드에서는 검색 창을 표시
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: '검색어를 입력하세요',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (searchQuery) {
                  // 검색어 입력 시 동작할 작업 추가
                },
              )
            : const Text(
                '스토어',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.cancel : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching; // 검색 버튼을 누를 때 검색 모드 토글
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
            const SizedBox(
              height: 6.5,
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Store').snapshots(),
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
                        padding: const EdgeInsets.all(10.0),
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
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white),
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
    );
  }
}
