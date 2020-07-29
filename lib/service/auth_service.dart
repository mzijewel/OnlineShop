import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/models/mOrderItem.dart';
import 'package:flutter_onlie_shop/models/user.dart';
import 'package:flutter_onlie_shop/screens/login/login_screen.dart';

import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _user(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_user);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _user(user).uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in
  Future signIn(String email, String pass) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUsersData(email);
      return _user(user).uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //registration
  Future registration(String email, String pass, String name, String phone,
      String photoUrl) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid)
          .saveUser(email, name, phone, photoUrl);
      return _user(user).uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      return Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
