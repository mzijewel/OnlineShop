import 'dart:async';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/db/database.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/models/mCartItem.dart';
import 'package:flutter_onlie_shop/models/mFav.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:flutter_onlie_shop/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:flutter_onlie_shop/utilities/global.dart';
import 'package:provider/provider.dart';

import 'components/cart_counter.dart';
import 'components/color_size.dart';
import 'components/description.dart';
import 'components/product_title_with_image.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({Key key, this.product}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with RouteAware {
  int _counter = 1;
  bool _isShake = false;
  bool _isFav = false, _isCart = false;
  Future<List<MCartItem>> _list;
  List<MCartItem> cartItems = [];
  Future<List<MFav>> _favFuture;
  List<MFav> favItems = [];
  AppDatabase db;

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
    print("Product: ${widget.product.title}");
    getCartData();
    getFavData();
  }

  initDb() async {
//    final migration1to2 = Migration(1, 2, (database) async {
//      await database.execute('ALTER TABLE MOrder');
//    });
    db = await $FloorAppDatabase.databaseBuilder('OS.db').build();
    getCartData();
    getFavData();
  }

  void save(String title, int price, int id, int cartQuantity, String image) {
    MCartItem person = MCartItem(
        title: title,
        price: price,
        id: id,
        catQuantity: cartQuantity,
        image: image);
    db.myDao.insertCart(person);
    getCartData();
  }

  void getCartData() {
    _list = db.myDao.getCartItems();
    _list.then((value) {
      setState(() {
        cartItems = value;
        var cartItem = Provider.of<CartItem>(context, listen: false);
        cartItem.updateCartSize(cartItems.length);
        if (_hasCart(widget.product.id)) {
          setState(() {
            _isCart = true;
          });
        } else {
          setState(() {
            _isCart = false;
          });
        }
      });
    });
  }

  void getFavData() {
    _favFuture = db.myDao.getFav();
    _favFuture.then((value) {
      setState(() {
        favItems = value;
        if (_hasFav(widget.product.id)) {
          setState(() {
            _isFav = true;
            var cartItem = Provider.of<CartItem>(context, listen: false);
            cartItem.updateFav(_isFav);
          });
          print("has fav");
        } else {
          setState(() {
            _isFav = false;
            var cartItem = Provider.of<CartItem>(context, listen: false);
            cartItem.updateFav(_isFav);
          });
          print("not fav");
        }
      });
    });
  }

  bool _hasCart(int id) {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].id == id) {
        return true;
      }
    }
    return false;
  }

  bool _hasFav(int id) {
    for (int i = 0; i < favItems.length; i++) {
      if (favItems[i].id == id) {
        return true;
      }
    }
    return false;
  }

  saveFavFb(MFav mFav) {
    db.myDao.saveFav(mFav);
    getFavData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.product.color,
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            children: <Widget>[
              SizedBox(
                child: Stack(children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    padding: EdgeInsets.only(
                        top: size.height * 0.12,
                        left: kDefaultPadding,
                        right: kDefaultPadding),
                    height: size.height * 0.57,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    child: SingleChildScrollView(
//                  physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          ColorAndSize(
                            product: widget.product,
                          ),
                          SizedBox(
                            height: kDefaultPadding / 4,
                          ),
                          CartCounter(
                            product: widget.product,
                          ),
                          SizedBox(
                            height: kDefaultPadding / 2,
                          ),
                          Description(
                            product: widget.product,
                          ),
                          SizedBox(
                            height: kDefaultPadding *2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ProductTitleWithImage(
                    product: widget.product,
                  )
                ]),
              ),
            ],
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: _addToCart(),
          ),
        ],
      ),
    );
  }

  Padding _addToCart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          Consumer<CartItem>(
            builder: (BuildContext context, CartItem value, Widget child) {
              return IconButton(
                icon: Icon(
                  value.isFav != null && value.isFav
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.redAccent,
                  size: 40,
                ),
                onPressed: () async {
//                      _isFav = !_isFav;
//                      var cartItem =
//                          Provider.of<CartItem>(context, listen: false);
//                      cartItem.updateFav(_isFav);

                  if (!_isFav) {
                    MFav mFav = new MFav();
                    mFav.id = widget.product.id;
                    mFav.description = widget.product.description;
                    mFav.title = widget.product.title;
                    mFav.price = widget.product.price;
                    mFav.size = widget.product.size;
                    mFav.image = widget.product.image;
                    saveFavFb(mFav);
                  } else {
                    db.myDao.deleteFav(widget.product.id);
                    getFavData();
                  }
                },
              );
            },
          ),
          SizedBox(width: 10,),
          Expanded(
            child: SizedBox(
              height: 50,
              child: Consumer<CartItem>(
                builder: (BuildContext context, CartItem value, Widget child) {
                  return FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: widget.product.color,
                    onPressed: () {
                      if (_isCart) {
                        db.myDao.deleteCart(widget.product.id);
                        getCartData();
                      } else {
                        save(
                            widget.product.title,
                            widget.product.price,
                            widget.product.id,
                            value.productQuantity != null &&
                                    value.productQuantity > 0
                                ? value.productQuantity
                                : 1,
                            widget.product.image);
                      }
                    },
                    child: Text(
                      _isCart
                          ? "Remove from cart".toUpperCase()
                          : "Add to cart".toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.product.title),
      backgroundColor: widget.product.color,
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
        Consumer<CartItem>(
          builder: (BuildContext context, CartItem value, Widget child) {
            if (value.cartSize != null) {
              print("DetailsScreen: $_counter cart: ${value.cartSize}");
              if (_counter != value.cartSize) {
                _isShake = true;
                print(_isShake);
                if (_isShake) {
                  Timer(Duration(seconds: 1), () {
                    setState(() {
                      _isShake = false;
                    });
                  });
                } else
                  _isShake = false;
              }

              _counter = value.cartSize;
            } else
              _counter = cartItems.length;

            return Badge(
              position: BadgePosition.topRight(top: 0, right: 3),
              animationDuration: Duration(seconds: 2),
              animationType: BadgeAnimationType.slide,
              showBadge: _counter > 0,
              badgeContent: Text(
                _counter.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: ShakeAnimatedWidget(
                  enabled: _isShake,
                  duration: Duration(milliseconds: 300),
                  shakeAngle: Rotation.deg(z: 40),
                  curve: Curves.linear,
                  child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<CartItem>(
                                create: (BuildContext context) => CartItem(),
                                child: ShoppingCartScreen(),
                              ),
                            ));
                      })),
            );
          },
        ),
        SizedBox(
          width: kDefaultPadding / 2,
        )
      ],
    );
  }
}
