import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/models/product.dart';

class Description extends StatelessWidget {
  final Product product;

  const Description({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Text(
        product.description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
