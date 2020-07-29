import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/db/database.dart';
import 'package:flutter_onlie_shop/models/mOrder.dart';
import 'package:flutter_onlie_shop/models/mOrderItem.dart';

class OrderDetailsScreen extends StatefulWidget {
  final MOrder order;

  const OrderDetailsScreen({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Future<List<MOrderItem>> _orderFuture;
  Stream<MOrder> _orderDetailsStream;
  List<MOrderItem> orderItems = [];
  AppDatabase db;
  MOrder _order;
  String orderStatus = "";

  initDb() async {
    db = await $FloorAppDatabase.databaseBuilder('OS.db').build();
    getData();
  }

  getData() {
    _orderFuture = db.myDao.getOrderItems(widget.order.id);
    _orderDetailsStream = db.myDao.getOrderById(widget.order.id);
    _orderDetailsStream.listen((event) {
      setState(() {
        _order = event;
      });
    });
    _orderFuture.then((value) {
      setState(() {
        orderItems = value;
        print("OrderItems: ${value.length}");
      });
    });
  }

  void cancelOrder() {
    MOrder mOrder = MOrder(
        id: _order.id,
        numberOfProduct: orderItems.length,
        orderDate: _order.orderDate,
        orderStatus: "Cancel",
        totalPrice: _order.totalPrice);
    db.myDao.insertOrder(mOrder);
    orderStatus = "Cancel";
    getData();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      orderStatus = widget.order.orderStatus;
    });
    initDb();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 60),
            child: Column(
              children: <Widget>[
                _orderDetails(size),
                _billingAddress(size),
                _paymentMethod(size),
                _products(size)
              ],
            ),
          ),
          orderStatus == "Cancel"
              ? Container()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: cancelOrder,
                    child: Container(
                      height: 50,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "Cancel Order",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Container _orderDetails(Size size) {
    return Container(
      height: 130,
      color: Colors.white,
      child: Card(
        elevation: 2,
        semanticContainer: true,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        borderOnForeground: true,
        child: Column(
          children: <Widget>[
            Container(
              width: size.width,
              padding: EdgeInsets.all(4),
              height: 25,
              color: Colors.grey,
              child: Text(
                "Order Details",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Number of product"),
                      Text(widget.order.numberOfProduct.toString())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Total Price"),
                      Text("\$${widget.order.totalPrice}")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Order Status"), Text(orderStatus)],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Order Date"),
                      Text(widget.order.orderDate)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _billingAddress(Size size) {
    return Container(
      height: 120,
      color: Colors.white,
      child: Card(
        elevation: 2,
        semanticContainer: true,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        borderOnForeground: true,
        child: Column(
          children: <Widget>[
            Container(
              width: size.width,
              padding: EdgeInsets.all(4),
              height: 25,
              color: Colors.grey,
              child: Text(
                "Billing Address",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Address"),
                      Text("Mohammadpur,6/9")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("City"), Text("Dhaka")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Zip Code"), Text("1207")],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _paymentMethod(Size size) {
    return Container(
      color: Colors.white,
      child: Card(
        elevation: 2,
        semanticContainer: true,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        borderOnForeground: true,
        child: Wrap(
          children: <Widget>[
            Container(
              width: size.width,
              padding: EdgeInsets.all(4),
              height: 25,
              color: Colors.grey,
              child: Text(
                "Payment Method",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Cash on delivery",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _products(Size size) {
    return Card(
      elevation: 2,
      semanticContainer: true,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      borderOnForeground: true,
      child: Wrap(
        children: <Widget>[
          Container(
            width: size.width,
            padding: EdgeInsets.all(4),
            height: 25,
            color: Colors.grey,
            child: Text(
              "Products",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              return _productRow(index);
            },
          )
        ],
      ),
    );
  }

  Padding _productRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: orderItems[index].image != null
                ? Image.asset(orderItems[index].image)
                : Container(),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(orderItems[index].title),
                    Text("\$${orderItems[index].price}"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 6,
                    ),
                    Text("Cart quantity: "),
                    Text(
                      orderItems[index].catQuantity.toString().padLeft(2, '0'),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Spacer(),
                    Text(
                        "\$${orderItems[index].price * orderItems[index].catQuantity}")
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
