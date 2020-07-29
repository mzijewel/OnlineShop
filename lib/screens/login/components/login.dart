import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/animation/fade_animation.dart';
import 'package:flutter_onlie_shop/loading_dia.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen_new.dart';
import 'package:flutter_onlie_shop/screens/signUp/sign_up_screen.dart';
import 'package:flutter_onlie_shop/screens/login/components/social/social_sign.dart';
import 'package:flutter_onlie_shop/service/auth_service.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
//  String pass, email;
  final _formKey = GlobalKey<FormState>();
  var _nameController = new TextEditingController();
  var _passController = new TextEditingController();
  String error = "";
  final AuthService _authService = AuthService();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.addListener(() {
      print(_nameController.text);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingDia()
        : Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60))),
            child: Padding(
              padding: EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    FadeAnimation(
                        1.5,
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  colors: [
                                    Colors.white,
                                    Colors.redAccent,
                                  ]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10,
                                    offset: Offset(0, 10)),
                              ]),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.email),
                                        ),
                                        labelText: 'Email',
                                        labelStyle:
                                            TextStyle(color: Colors.brown),
                                        border: InputBorder.none),
                                    validator: (val) =>
                                        val.isEmpty ? "Enter email" : null,
//                              onChanged: (value) {
//                                setState(() => email = value);
//                              },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(14),
                                  child: TextFormField(
                                    controller: _passController,
                                    decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.lock_outline),
                                        ),
                                        labelText: 'Password',
                                        labelStyle:
                                            TextStyle(color: Colors.brown),
                                        border: InputBorder.none),
                                    validator: (val) =>
                                        val.isEmpty ? "Enter Password" : null,
//                            onChanged: (value) {
//                              setState(() => pass = value);
//                            },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        1.6,
                        Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.grey),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.7,
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              //dismiss soft board
                              setState(() {
                                loading = true;
                              });
                              FocusScope.of(context).unfocus();
                              dynamic result = await _authService.signIn(
                                  _nameController.text, _passController.text);
                              print(result);
                              if (result == null) {
                                setState(() {
                                  error =
                                      "could not sign in with those credintial";
                                  loading = false;
                                });
                              } else {
                                loading = false;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider<CartItem>(
                                        create: (BuildContext context) =>
                                            CartItem(),
                                        child: HomeScreenNew(),
                                      ),
                                    ));
                              }
                            } else {
                              print("Not Validate: ");
                            }
                          },
                          child: Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: LinearGradient(colors: [
                                  Colors.orange[900],
                                  Colors.orange[700],
                                  Colors.orange[500]
                                ])),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.8,
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen())),
                          child: Text(
                            "Create new acc.",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    SocialSign()
                  ],
                ),
              ),
            ),
          );
  }
}
