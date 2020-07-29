import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen_new.dart';
import 'package:flutter_onlie_shop/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future(() async {
      if (await _auth.currentUser() != null) {
        print("Logged");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider<CartItem>(
                    create: (BuildContext context) => CartItem(),
                    child: HomeScreenNew(),
                  ),
            ));
      } else {
        print("Not Logged");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrange,
    );
  }
}
