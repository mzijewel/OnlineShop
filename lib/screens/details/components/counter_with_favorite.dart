import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:flutter_onlie_shop/screens/details/components/cart_counter.dart';

class CounterWithFavBtn extends StatefulWidget {
  final Product product;

  const CounterWithFavBtn({Key key, this.product}) : super(key: key);

  @override
  _CounterWithFavBtnState createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<CounterWithFavBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(),
//        RichText(
//            text: TextSpan(children: [
//          TextSpan(
//              text: 'Total price\n', style: TextStyle(color: Colors.brown)),
//          TextSpan(
//            text: '\$ ${widget.product.price}',
//            style: Theme.of(context)
//                .textTheme
//                .headline4
//                .copyWith(color: Colors.orange, fontWeight: FontWeight.bold),
//          )
//        ])),

//        Container(
//          width: 32,
//          height: 32,
//          decoration:
//              BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
//          child: Center(
//            child: Icon(
//              Icons.favorite,
//              color: Colors.white,
//            ),
//          ),
//        )
      ],
    );
  }
}
