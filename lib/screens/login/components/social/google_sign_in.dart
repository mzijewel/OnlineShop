import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen_new.dart';
import 'package:flutter_onlie_shop/service/database_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleSign extends StatefulWidget {
  @override
  _GoogleSignState createState() => _GoogleSignState();
}

class _GoogleSignState extends State<GoogleSign> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        print(_currentUser.email);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final FirebaseUser user =
          (await FirebaseAuth.instance.signInWithCredential(authCredential))
              .user;
      if (user != null) {
        print("Signed in: " + user.displayName);
        await DatabaseService(uid: user.uid).setFbGoogleData(
            user.email, user.displayName, user.phoneNumber, user.photoUrl);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<CartItem>(
                create: (BuildContext context) => CartItem(),
                child: HomeScreenNew(),
              ),
            ));
      } else {
        print("Signed null: ");
      }
      return user;
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_currentUser != null) {
          print("signout");
          _handleSignOut();
        } else
          _handleSignIn();
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(colors: [
              Colors.pink[900],
              Colors.pink[700],
              Colors.pink[500]
            ])),
        child: Center(
          child: Text(
            "Google",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
