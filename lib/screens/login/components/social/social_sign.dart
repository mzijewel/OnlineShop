import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/animation/fade_animation.dart';
import 'package:flutter_onlie_shop/screens/login/components/social/facebook_login.dart';
import 'package:flutter_onlie_shop/screens/login/components/social/google_sign_in.dart';

class SocialSign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FadeAnimation(1.9, FbLogin()),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FadeAnimation(2.0, GoogleSign()),
        ),
      ],
    );
  }
}
