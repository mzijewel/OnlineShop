import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_onlie_shop/constants.dart';
import 'package:flutter_onlie_shop/screens/home/components/image_slider.dart';
import 'package:flutter_onlie_shop/screens/login/login_screen.dart';
import 'package:flutter_onlie_shop/screens/shoppingCart/shopping_cart_screen.dart';
import 'package:flutter_onlie_shop/service/auth_service.dart';
import 'components/main_drawer.dart';
import 'package:flutter_onlie_shop/screens/home/components/body.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, name, photoUrl;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getUser() async {
    await _auth.currentUser().then((value) {
      print(value.email);
      setState(() {
        name = value.displayName;
        email = value.email;
      });
    });
  }

  getDataFromFireStore() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("Users")
        .document(firebaseUser.uid)
        .get()
        .then((value) {
      print(value.data["photoUrl"]);
      setState(() {
        photoUrl = value.data["photoUrl"];
      });
    });
  }

  getRealTimeData() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('Users')
        .document(firebaseUser.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        print("run data: ${event.data["phone"]}");
      });
    });

  }

  @override
  void initState() {
    super.initState();
    getUser();
    getDataFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      body: Column(
        children: <Widget>[
          ImageSlider(),
          Expanded(child: Body()),
        ],
      ),
      drawer: SafeArea(
          child: MainDrawer(
        name: name,
        email: email,
        photoUrl: photoUrl,
      )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    AuthService _authService = AuthService();
    FacebookLogin facebookSignIn = new FacebookLogin();
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    Future<void> _fbLogOut() async {
      await facebookSignIn.logOut();
    }

    Future<void> _googleSignOut() => _googleSignIn.disconnect();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.brown,
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: null),
        IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.brown,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingCartScreen(),
                  ));
            }),
        FlatButton.icon(
            onPressed: () async {
              _authService.signOut(context);
            },
            icon: Icon(Icons.person),
            label: Text("Logout")),
        SizedBox(
          width: kDefaultPadding / 2,
        )
      ],
    );
  }
}
