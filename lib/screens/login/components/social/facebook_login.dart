import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen_new.dart';
import 'package:flutter_onlie_shop/service/database_service.dart';
import 'package:provider/provider.dart';

class FbLogin extends StatefulWidget {
  @override
  _FbLoginState createState() => _FbLoginState();
}

class _FbLoginState extends State<FbLogin> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';

  void _showMessage(String message) {
    setState(() {
      _message = message;
      print(_message);
    });
  }

  Future<void> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final AuthCredential authCredential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        final FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(authCredential))
                .user;
        if (user != null) {
          print("Signed in: " + user.email);
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

        _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print("FB Error: ${result.errorMessage}");
//        _showMessage('Something went wrong with the login process.\n'
//            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _login(),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(colors: [
              Colors.teal[900],
              Colors.teal[700],
              Colors.teal[500]
            ])),
        child: Center(
          child: Text(
            "Facebook",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
