import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onlie_shop/animation/fade_animation.dart';
import 'package:flutter_onlie_shop/loading_dia.dart';
import 'package:flutter_onlie_shop/models/cart_item.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen.dart';
import 'package:flutter_onlie_shop/screens/home/home_screen_new.dart';
import 'package:flutter_onlie_shop/service/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  var _nameController = new TextEditingController();
  var _emailController = new TextEditingController();
  var _phoneController = new TextEditingController();
  var _passController = new TextEditingController();
  final AuthService _authService = AuthService();
  File imageURI;
  final picker = ImagePicker();
  String error = "";
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
    _emailController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imageURI = File(pickedFile.path);
      String fileName = pickedFile.path.split("/").last;
      print("file name: ${fileName}");
    });
  }

  Future<void> _imageUploadToFirebase(File image) async {
    try {
      int randomNumber = Random().nextInt(100000);
      String imageLocation = "profile/image${randomNumber}.jpg";
      //Upload image to firebase
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imageLocation);
      final StorageUploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;
      _saveDataFireStore(imageLocation);
    } catch (e) {
      print("error: ${e}");
    }
  }

  Future<void> _saveDataFireStore(String imageLocation) async {
    try {
      final ref = FirebaseStorage().ref().child(imageLocation);
      ref.getDownloadURL().then((value) async {
        print("ImageUrl: " + value.toString());
        dynamic result = await _authService.registration(
            _emailController.text,
            _passController.text,
            _nameController.text,
            _phoneController.text,
            value.toString());
        if (result == null) {
          setState(() {
            error = "please supply a valid email";
            loading = false;
          });
        } else {
          print("Registration");
          loading = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<CartItem>(
                      create: (BuildContext context) => CartItem(),
                      child: HomeScreenNew(),
                    ),
              ));
        }
      });
    } catch (e) {}
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
              padding: EdgeInsets.only(top: 6, left: 18, right: 18, bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 6,
                    ),
                    InkWell(
                      onTap: () => getImageFromGallery(),
                      child: FadeAnimation(
                        1.5,
                        ClipOval(
                            child: imageURI != null
                                ? Image.file(imageURI,
                                    width: 60, height: 60, fit: BoxFit.cover)
                                : Container(
                                    color: Colors.grey,
                                    width: 60,
                                    height: 60,
                                    child: Icon(Icons.person_pin),
                                  )),
                      ),
                    ),
                    FadeAnimation(
                        1.5,
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  colors: [
                                    Colors.white,
                                    Colors.teal,
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
                                          icon: Icon(Icons.person_pin),
                                        ),
                                        labelText: 'Name',
                                        labelStyle:
                                            TextStyle(color: Colors.brown),
                                        border: InputBorder.none),
                                    validator: (val) =>
                                        val.isEmpty ? "Enter name" : null,
//                              onChanged: (value) {
//                                setState(() => email = value);
//                              },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.email),
                                        ),
                                        labelText: 'Email',
                                        labelStyle:
                                            TextStyle(color: Colors.brown),
                                        border: InputBorder.none),
                                    validator: (val) =>
                                        val.isEmpty ? "Enter Email" : null,
//                            onChanged: (value) {
//                              setState(() => pass = value);
//                            },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextFormField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.phone),
                                        ),
                                        labelText: 'Phone',
                                        labelStyle:
                                            TextStyle(color: Colors.brown),
                                        border: InputBorder.none),
                                    validator: (val) =>
                                        val.isEmpty ? "Enter Phone" : null,
//                            onChanged: (value) {
//                              setState(() => pass = value);
//                            },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(14),
                                  child: TextFormField(
                                    controller: _passController,
                                    keyboardType: TextInputType.visiblePassword,
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
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
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
                              _imageUploadToFirebase(imageURI);
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
                                  Colors.teal[900],
                                  Colors.teal[700],
                                  Colors.teal[500]
                                ])),
                            child: Center(
                              child: Text(
                                "Sign Up".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
