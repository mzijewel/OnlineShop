import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/db/database.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/models/mFav.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:flutter_onlie_shop/screens/details/details_screen.dart';
import 'package:flutter_onlie_shop/utilities/global.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class FavScreen extends StatefulWidget {
  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> with RouteAware {
  Future<List<MFav>> _favFuture;
  List<MFav> favItems = [];
  AppDatabase db;

  initDb() async {
    db = await $FloorAppDatabase.databaseBuilder('OS.db').build();
    getFavData();
  }

  void getFavData() {
    _favFuture = db.myDao.getFav();
    _favFuture.then((value) {
      setState(() {
        favItems = value;
        print("fav: ${favItems.length}");
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDb();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Global.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    Global.routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when the top route has been popped off, and the current route shows up.
  @override
  void didPopNext() {
    super.didPopNext();
    getFavData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Fav"),
      ),
      body: favItems.length > 0
          ? GridView.builder(
              itemCount: favItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding),
              itemBuilder: (context, index) => _favRow(index),
            )
          : Center(
              child: Text("No Record Found"),
            ),
    );
  }

  GestureDetector _favRow(int index) {
    return GestureDetector(
      onTap: () {
        Product product = new Product();
        product.id = favItems[index].id;
        product.image = favItems[index].image;
        product.description = favItems[index].description;
        product.price = favItems[index].price;
        product.title = favItems[index].title;
        product.size = favItems[index].size;
        product.catQuantity = 1;
        product.color = Colors.teal;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<CartItem>(
                      create: (BuildContext context) => CartItem(),
                      child: DetailsScreen(
                        product: product,
                      ),
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding / 5),
        height: 120,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(1.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white,
          border: Border.all(style: BorderStyle.solid, color: Colors.white60),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
//                padding: EdgeInsets.all(kDefaultPadding),
//                height: 120,
//                width: 160,
//                decoration: BoxDecoration(
//                  color: product.color,
//                  borderRadius: BorderRadius.circular(16),
//                ),
                child: Hero(
                    tag: '${favItems[index].id}',
                    child: favItems[index].image != null
                        ? Image.asset(
                            favItems[index].image,
                            height: 80,
                            width: 160,
                            fit: BoxFit.fill,
                          )
                        : Container()),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
              child: Text(
                favItems[index].title,
                style: TextStyle(color: Colors.teal),
              ),
            ),
            Text(
              '\$${favItems[index].price}',
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                db.myDao.deleteFav(favItems[index].id);
                getFavData();
              },
              child: Container(
                height: 25,
                width: 170,
                color: Colors.redAccent,
                child: Center(
                  child: Text(
                    "Remove from fav".toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
