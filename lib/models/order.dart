// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

import 'orderItem.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.id,
    this.numberOfProduct,
    this.totalPrice,
    this.orderStatus,
    this.orderDate,
    this.orderItems,
  });

  int id;
  int numberOfProduct;
  double totalPrice;
  String orderStatus;
  String orderDate;
  List<OrderItem> orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        numberOfProduct: json["numberOfProduct"],
        totalPrice: json["totalPrice"].toDouble(),
        orderStatus: json["orderStatus"],
        orderDate: json["orderDate"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "numberOfProduct": numberOfProduct,
        "totalPrice": totalPrice,
        "orderStatus": orderStatus,
        "orderDate": orderDate,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}


