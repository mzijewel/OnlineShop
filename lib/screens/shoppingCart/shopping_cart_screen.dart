import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_onlie_shop/db/database.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/models/mCartItem.dart';
import 'package:flutter_onlie_shop/models/mOrder.dart';
import 'package:flutter_onlie_shop/models/mOrderItem.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:flutter_onlie_shop/screens/myOrder/my_order_screen.dart';
import 'package:flutter_onlie_shop/service/auth_service.dart';
import 'package:flutter_onlie_shop/utilities/global.dart';
import 'package:flutter_onlie_shop/utilities/utils.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with RouteAware {
  Future<List<MCartItem>> _list;
  List<MCartItem> data = [];
  List<MOrderItem> _orderItems = [];
  AppDatabase db;
  double totalAmount;
  int numOfItems = 1, totalPrice;
  MCartItem product;
  bool _isCartHas = false;
  String userID;
  FirebaseAuth _auth = FirebaseAuth.instance;

  initDb() async {
    db = await $FloorAppDatabase.databaseBuilder('OS.db').build();
    getData();
    Future(() async {
      if (await _auth.currentUser() != null) {
        _auth.currentUser().then((value) {
          userID = value.uid;
        });
      } else {
        print("Not Logged");
      }
    });
  }

  void getData() {
    _list = db.myDao.getCartItems();
    _list.then((value) {
      setState(() {
        data = value;
        var cart = Provider.of<CartItem>(context, listen: false);
        cart.updateCartSize(data.length);
        if (data.length > 0) {
          setState(() {
            _isCartHas = true;
          });

          print("List : ${value[0].id}");
          calTotalAmount();
        } else {
          setState(() {
            _isCartHas = false;
          });
        }
      });
      value.forEach((element) {
        print("List : ${element.id}");
      });
//      print(value.forEach((element) {
//
//      }));
    });
  }

  double calTotalAmount() {
    totalAmount = 0;
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        totalAmount += data[i].price * data[i].catQuantity;
      }
    }

    return totalAmount;
  }

  void updateCart(
      String title, int price, int id, int cartQuantity, String image) {
    MCartItem person = MCartItem(
        title: title,
        price: price,
        id: id,
        catQuantity: cartQuantity,
        image: image);
    db.myDao.insertCart(person);
  }

  saveOrderFb(String userID, int numberOfProduct, String orderDate,
      String orderStatus, double totalPrice, List<MOrderItem> orderItems) {
    Firestore.instance.collection('Orders').document(userID).setData({
      "numberOfProduct": numberOfProduct,
      "orderDate": orderDate,
      "orderStatus": orderStatus,
      "totalPrice": totalPrice,
      "products": orderItems,
    });
  }

  void save() {
    MOrder mOrder = MOrder(
        numberOfProduct: data.length,
        orderDate: Utils.getCurrentDateTime(),
        orderStatus: "Pending",
        totalPrice: calTotalAmount());
    var id = db.myDao.insertOrder(mOrder);
    id.then((value) {
      print("OrderId: $value");
      for (int i = 0; i < data.length; i++) {
        MOrderItem orderItem = new MOrderItem();
        orderItem.parenId = value;
        orderItem.size = data[i].size;
        orderItem.title = data[i].title;
        orderItem.catQuantity = data[i].catQuantity;
        orderItem.price = data[i].price;
        orderItem.image = data[i].image;
//        db.myDao.saveOrderItem(orderItem);
        _orderItems.add(orderItem);
      }
//      saveOrderFb(userID, data.length, Utils.getCurrentDateTime(), "Pending",
//          calTotalAmount(), _orderItems);
      print("OrderItems Save: ${_orderItems.length}");
      db.myDao.insertOrderItem(_orderItems);
      db.myDao.deleteCartAll();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MyOrderScreen(),
      ));
    });
  }

  @override
  void initState() {
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
    print("ShoppingCart:");
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopping Cart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<CartItem>(
          builder: (BuildContext context, CartItem value, Widget child) {
            return Column(
              children: <Widget>[
                Expanded(
                    child: data.length < 1 ? CartEmptyView() : _cartView()),
                InkWell(
                  onTap: () => save(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: value.cartSize != null && value.cartSize > 0
                            ? Colors.teal
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                        child: Text(
                      "Proceed".toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                  ),
                ),
                SizedBox(
                  height: 16,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Column _cartView() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 7,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              product = data[index];
              return Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 80,
                    height: 80,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(products[index].image),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(data[index].title),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            buildOutLineButton(
                                icon: Icons.remove,
                                press: () {
                                  numOfItems = data[index].catQuantity;
                                  if (numOfItems > 1) {
                                    setState(() {
                                      numOfItems--;
                                      print(
                                          "items: $numOfItems totalPrice: ${product.price}");
                                      totalPrice = product.price * numOfItems;
//                                      data[index].price = totalPrice;
                                      data[index].catQuantity = numOfItems;
                                      updateCart(
                                          data[index].title,
                                          totalPrice,
                                          data[index].id,
                                          data[index].catQuantity,
                                          data[index].image);
                                    });
                                  }
                                }),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              data[index]
                                  .catQuantity
                                  .toString()
                                  .padLeft(2, '0'),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            buildOutLineButton(
                                icon: Icons.add,
                                press: () {
                                  setState(() {
                                    numOfItems = data[index].catQuantity;
                                    numOfItems++;
                                    print(
                                        "items: $numOfItems totalPrice: ${product.price}");
                                    totalPrice = product.price * numOfItems;
//                                    data[index].price = totalPrice;
                                    data[index].catQuantity = numOfItems;
                                    updateCart(
                                        data[index].title,
                                        totalPrice,
                                        data[index].id,
                                        data[index].catQuantity,
                                        data[index].image);
                                    print(
                                        "Total ${data[index].price}  quantity: ${data[index].catQuantity}");
                                  });
                                }),
                            SizedBox(
                              width: 6,
                            ),
                            Consumer<CartItem>(
                              builder: (BuildContext context, CartItem value,
                                  Widget child) {
                                return buildOutLineButton(
                                    icon: Icons.close,
                                    press: () {
                                      setState(() {
                                        db.myDao.deleteCart(data[index].id);
                                        getData();
                                      });
                                    });
                              },
                            ),
                            Spacer(),
                            Text(
                                "\$${data[index].price * data[index].catQuantity}")
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: _isCartHas
              ? CalculateView(
                  totalAmount: calTotalAmount(),
                )
              : Container(),
          flex: 2,
        )
      ],
    );
  }

  SizedBox buildOutLineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}

class CartEmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Your cart is empty"),
          RaisedButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Explore",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class CalculateView extends StatelessWidget {
  final double totalAmount;

  const CalculateView({Key key, this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double subTotal = totalAmount + 50;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Total"),
            Text("\$${totalAmount.toString()}"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Delivery Charge"),
            Text("\$50"),
          ],
        ),
        Divider(
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Sub Total",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            Text(
              "\$${subTotal.toString()}",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
