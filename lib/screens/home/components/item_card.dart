import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/models/product.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  final Function press, addCart;
  final String cartTitle;

  const ItemCard(
      {Key key, this.product, this.press, this.addCart, this.cartTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
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
                    tag: '${product.id}',
                    child: Image.asset(
                      product.image,
                      height: 80,
                      width: 160,
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
              child: Text(
                product.title,
                style: TextStyle(color: product.color),
              ),
            ),
            Text(
              '\$${product.price}',
              style:
                  TextStyle(color: product.color, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: addCart,
              child: Container(
                height: 25,
                width: 170,
                color: Colors.redAccent,
                child: Center(
                  child: Text(
                    cartTitle.toUpperCase(),
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
