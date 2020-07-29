import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_onlie_shop/models/mOrderItem.dart';
import 'package:flutter_onlie_shop/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference users = Firestore.instance.collection("Users");
  final CollectionReference orders = Firestore.instance.collection("Orders");

  Future saveUser(
      String email, String name, String phone, String photoUrl) async {
    return await users.document(uid).setData({
      "email": email,
      "name": name,
      "phone": phone,
      "photoUrl": photoUrl,
    });
  }

  Future updateUsersData(String email) async {
    return await users.document(uid).setData({
      "email": email,
    });
  }

  Future setFbGoogleData(
      String email, String name, String phone, String photoUrl) async {
    return await users.document(uid).setData({
      "email": email,
      "name": name,
      "phone": phone,
      "photoUrl": photoUrl,
    });
  }

  saveOrderFb(String userID, int numberOfProduct, String orderDate,
      String orderStatus, double totalPrice, List<MOrderItem> orderItems) {
    Firestore.instance.collection('Orders').document(userID).setData({
      "numberOfProduct": numberOfProduct,
      "orderDate": orderDate,
      "orderStatus": orderStatus,
      "totalPrice": totalPrice,
      "products": orderItems,
    });
  }

  //user list from snapshot
  List<User> _userList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User(
        name: doc.data["name"] ?? "",
        email: doc.data["email"] ?? "0",
        phone: doc.data["phone"] ?? 0,
      );
    }).toList();
  }

  Stream<List<User>> get getUser {
    return users.snapshots().map(_userList);
  }
}
