import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/db/database.dart';
import 'package:flutter_onlie_shop/models/mOrder.dart';
import 'package:flutter_onlie_shop/models/mOrderItem.dart';
import 'package:flutter_onlie_shop/screens/myOrder/order_details_screen.dart';
import 'package:flutter_onlie_shop/utilities/global.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>  with RouteAware{
  Future<List<MOrder>> _list;
  Future<List<MOrderItem>> _orderItems;
  List<MOrder> data = [];
  AppDatabase db;

  initDb() async {
//    final migration1to2 = Migration(1, 2, (database) async {
//      await database.execute('ALTER TABLE MOrder');
//    });
    db = await $FloorAppDatabase.databaseBuilder('OS.db').build();
    getData();
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
    print("My Order:");
    getData();
  }

  getData() {
    _list = db.myDao.getOrders();
    _list.then((value) {
      setState(() {
        data = value;
      });
      value.forEach((element) {
        print("List : ${element.numberOfProduct}");
        _orderItems = db.myDao.getOrderItems(element.id);
        _orderItems.then((value) {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initDb();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Order"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _orderRow(index);
        },
      ),
    );
  }

  Container _orderRow(int index) {
    return Container(
      height: 150,
      color: Colors.white,
      child: Card(
        elevation: 2,
        semanticContainer: true,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        borderOnForeground: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4),
              height: 25,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Order ID",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    data[index].id.toString(),
                    style: TextStyle(color: Colors.white),
                  )
                ],
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
                      Text(data[index].numberOfProduct.toString())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Total Price"),
                      Text("\$${data[index].totalPrice}")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Order Status"),
                      Text(data[index].orderStatus)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Order Date"),
                      Text(data[index].orderDate)
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 25,
              padding: EdgeInsets.all(2),
              color: Colors.grey,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(
                          order: data[index],
                        ),
                      )),
                      child: Container(
                        width: 50,
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            "View",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
