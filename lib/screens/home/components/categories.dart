import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/constants.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = ["HandBags", "Jewellery", "Footwear", "Dresses"];
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected == index ? kTextColor : kTextLightColor),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPadding / 4),
              height: 2,
              width: 30,
              color: selected == index ? Colors.brown : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
