import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/animation/fade_animation.dart';
import 'package:flutter_onlie_shop/screens/login/components/login.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        Colors.orange[900],
        Colors.orange[700],
        Colors.orange[400],
      ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.11,
          ),
          Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: <Widget>[
                FadeAnimation(
                    1,
                    Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    )),
                SizedBox(
                  height: 10,
                ),
                FadeAnimation(
                    1.3,
                    Text(
                      'Welcome to flutter shop',
                      style: TextStyle(color: Colors.teal, fontSize: 20),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Login(),
          )
        ],
      ),
    );
  }
}
