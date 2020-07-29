import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:flutter_onlie_shop/screens/details/components/add_to_cart.dart';
import 'package:flutter_onlie_shop/screens/details/components/cart_counter.dart';
import 'package:flutter_onlie_shop/screens/details/components/color_size.dart';
import 'package:flutter_onlie_shop/screens/details/components/counter_with_favorite.dart';
import 'package:flutter_onlie_shop/screens/details/components/description.dart';
import 'package:flutter_onlie_shop/screens/details/components/product_title_with_image.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: size.height,
          child: Stack(children: [
            Container(
              margin: EdgeInsets.only(top: size.height * 0.4),
              padding: EdgeInsets.only(
                  top: size.height * 0.12,
                  left: kDefaultPadding,
                  right: kDefaultPadding),
//              height: 500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    ColorAndSize(
                      product: product,
                    ),
                    SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                    Description(
                      product: product,
                    ),
                    SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                    CartCounter(product: product,),
                    SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                    AddToCart(
                      product: product,
                    ),
                    SizedBox(height: kDefaultPadding,)
                  ],
                ),
              ),
            ),
            ProductTitleWithImage(
              product: product,
            )
          ]),
        ),
      ],
    ));
  }
}
