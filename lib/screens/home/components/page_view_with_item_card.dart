import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/db/database.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/models/mCartItem.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:flutter_onlie_shop/screens/details/details_screen.dart';
import 'package:flutter_onlie_shop/screens/home/components/item_card.dart';
import 'package:provider/provider.dart';

class PageViewWithItemCard extends StatefulWidget {
  @override
  _PageViewWithItemCardState createState() => _PageViewWithItemCardState();
}

class _PageViewWithItemCardState extends State<PageViewWithItemCard> {
  List<String> categories = ["HandBags", "Jewellery", "Footwear", "Dresses"];
  PageController controller = PageController();
  int selectedIndex = 0;
  Future<List<MCartItem>> _list;
  List<MCartItem> data = [];
  AppDatabase db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new PageController(
      initialPage: selectedIndex,
    );
    controller.addListener(() {
      setState(() {});
    });

    initDb();
  }

  initDb() async {
    db = await $FloorAppDatabase.databaseBuilder('OS.db').build();
    getData();
  }

  void save(String title, int price, int id, int cartQuantity) {
    MCartItem person = MCartItem(
        title: title, price: price, id: id, catQuantity: cartQuantity);
    db.myDao.insertCart(person);
    getData();
  }

  void getData() {
    _list = db.myDao.getCartItems();
    _list.then((value) {
      setState(() {
        data = value;
        var cartItem = Provider.of<CartItem>(context, listen: false);
        cartItem.updateCartSize(data.length);
      });
    });
  }

  bool _hasCart(int id) {
    for (int i = 0; i < data.length; i++) {
      if (data[i].id == id) {
        return true;
      }
    }
    return false;
  }

  void onPageChanged(int page) {
    setState(() {
      this.selectedIndex = page;
    });
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        print(index);
        this.controller.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceOut);
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedIndex == index ? kTextColor : kTextLightColor),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPadding / 4),
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.brown : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text(
            "Women",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: SizedBox(
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: 10),
          child: PageView.builder(
            onPageChanged: onPageChanged,
            controller: controller,
            itemBuilder: (context, position) {
              return GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: kDefaultPadding,
                    crossAxisSpacing: kDefaultPadding),
                itemBuilder: (context, index) => Consumer<CartItem>(
                  builder:
                      (BuildContext context, CartItem value, Widget child) {
                    return ItemCard(
                      cartTitle: _hasCart(products[index].id)
                          ? "Remove from cart"
                          : "Add to cart",
                      product: products[index],
                      press: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<CartItem>(
                                    create: (BuildContext context) =>
                                        CartItem(),
                                    child: DetailsScreen(
                                      product: products[index],
                                    ),
                                  ))),
                      addCart: () {
                        if (_hasCart(products[index].id)) {
                          db.myDao.deleteCart(products[index].id);
                          getData();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Remove from cart'),
                            duration: Duration(seconds: 1),
                          ));
                        } else {
                          save(
                              products[index].title,
                              products[index].price,
                              products[index].id,
                              value.productQuantity != null &&
                                      value.productQuantity > 0
                                  ? value.productQuantity
                                  : 1);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Added to cart'),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      },
                    );
                  },
                ),
              );
            },
            itemCount: categories.length,
          ),
        ))
      ],
    );
  }
}
