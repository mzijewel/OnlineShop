import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/models/product.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;

//  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Stack(children: <Widget>[
        CarouselSlider.builder(
          itemCount: products.length,
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.bounceIn,
            enlargeCenterPage: true,
            autoPlay: true,
          ),
          itemBuilder: (ctx, index) {
            return InkWell(
              onTap: () {
                print(index);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  products[index].image,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: products.map((url) {
                  int index = products.indexOf(url);
                  return Container(
                    width: 20,
                    height: 20,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                          style: BorderStyle.solid),
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Container(
                        width: _current == index ? 10.0 : 8.0,
                        height: _current == index ? 10.0 : 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.lightGreen
                              : Colors.deepOrange,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
