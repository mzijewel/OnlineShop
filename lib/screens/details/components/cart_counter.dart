import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:provider/provider.dart';

class CartCounter extends StatefulWidget {
  final Product product;

  const CartCounter({Key key, this.product}) : super(key: key);

  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int numOfItems = 1, totalPrice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPrice = widget.product.price;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartItem>(
      builder: (BuildContext context, CartItem value, Widget child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                buildOutLineButton(
                    icon: Icons.remove,
                    press: () {
                      if (numOfItems > 1) {
                        setState(() {
                          numOfItems--;
                          totalPrice = widget.product.price * numOfItems;
                          var cartItem =
                          Provider.of<CartItem>(context, listen: false);
                          cartItem.updateProductQuantity(numOfItems);
                        });
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2),
                  child: Text(
                    //if our items is less than 10 it show 01 02 like that
                    numOfItems.toString().padLeft(2, '0'),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                buildOutLineButton(
                    icon: Icons.add,
                    press: () {
                      setState(() {
                        numOfItems++;
                        totalPrice = widget.product.price * numOfItems;
                        var cartItem =
                            Provider.of<CartItem>(context, listen: false);
                        cartItem.updateProductQuantity(numOfItems);
                      });
                    }),
              ],
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Total price\n',
                  style: TextStyle(color: widget.product.color)),
              TextSpan(
                text: '\$$totalPrice',
                style: Theme.of(context).textTheme.headline4.copyWith(
                    color: widget.product.color, fontWeight: FontWeight.bold),
              )
            ]))
          ],
        );
      },
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
