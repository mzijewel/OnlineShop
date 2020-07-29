import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/models/product.dart';
import 'package:flutter_onlie_shop/screens/details/components/color_dot.dart';

class ColorAndSize extends StatefulWidget {
  final Product product;

  const ColorAndSize({Key key, this.product}) : super(key: key);

  @override
  _ColorAndSizeState createState() => _ColorAndSizeState();
}

class _ColorAndSizeState extends State<ColorAndSize> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Colors"),

              Container(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selected = index;
                        });
                      },
                      child: ColorDot(
                        color: products[index].color,
                        isSelected: selected == index ? true : false,
                      ),
                    );
                  },
                ),
              ),
//              ListView(
//                children: <Widget>[
//                  ColorDot(
//                    isSelected: true,
//                    color: Colors.brown,
//                  ),
//                  ColorDot(
//                    color: Colors.deepOrange,
//                  ),
//                  ColorDot(
//                    color: Colors.purpleAccent,
//                  )
//                ],
//              )
            ],
          ),
        ),
        Expanded(
          child: RichText(
              text: TextSpan(style: TextStyle(color: Colors.black), children: [
            TextSpan(text: "Sizes\n\n"),
            TextSpan(
                text: '${widget.product.size}',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold))
          ])),
        )
      ],
    );
  }
}
