import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/animation/fade_animation.dart';
import 'package:flutter_onlie_shop/screens/signUp/sign_up.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _body(size, context),
    );
  }

  Widget _body(Size size, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        Colors.teal[900],
        Colors.teal[700],
        Colors.teal[400],
      ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeAnimation(
                    1,
                    Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    )),
                SizedBox(
                  height: 10,
                ),
                FadeAnimation(
                    1.3,
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Login Back',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SignUp(),
          )
        ],
      ),
    );
  }
}
