import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/db/database.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/models/mCartItem.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:provider/provider.dart';

class AddToCart extends StatefulWidget {
  final Product product;

  const AddToCart({Key key, this.product}) : super(key: key);

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  AppDatabase db;
  int counter = 0;
  bool _isFav = false, _isCart = false;
  Future<List<MCartItem>> _list;
  List<MCartItem> data = [];

  initDb() async {
    db = await $FloorAppDatabase.databaseBuilder('OS.db').build();
    getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDb();
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
        var cartItem =
        Provider.of<CartItem>(context, listen: false);
        cartItem.updateCartSize(data.length);
        if (_hasCart(widget.product.id)) {
          setState(() {
            _isCart = true;
          });
          print("has");
        } else {
          setState(() {
            _isCart = false;
          });
          print("not");
        }
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: kDefaultPadding),
            width: 50,
            height: 58,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: widget.product.color)),
            child: Center(
              child: Consumer<CartItem>(
                builder: (BuildContext context, CartItem value, Widget child) {
                  return IconButton(
                    icon: Icon(
                      value.isFav != null && value.isFav
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                    onPressed: () async {
                      _isFav = !_isFav;
                      var cartItem =
                          Provider.of<CartItem>(context, listen: false);
                      cartItem.updateFav(_isFav);
                    },
                  );
                },
              ),
            ),
          ),
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
                      counter++;
//                      var cartItem =
//                          Provider.of<CartItem>(context, listen: false);
                      if (_isCart) {


                        db.myDao.deleteCart(widget.product.id);
                        getData();
                      } else {
//                        cartItem.updateCartSize(counter);
                        save(
                            widget.product.title,
                            widget.product.price,
                            widget.product.id,
                            value.productQuantity != null &&
                                    value.productQuantity > 0
                                ? value.productQuantity
                                : 1);
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
          )
        ],
      ),
    );
  }
}
