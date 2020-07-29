import 'package:flutter/material.dart';

class Product {
  String image, title, description;
  int id, price, size, catQuantity;
  Color color;

  Product(
      {this.image,
      this.title,
      this.description,
      this.id,
      this.price,
      this.catQuantity,
      this.size,
      this.color});
}

List<Product> products = [
  Product(
      id: 1,
      catQuantity: 1,
      title: 'Bag one',
      price: 234,
      size: 12,
      description: 'Write product descriptions in the natural language of your target customer.  the language your customers use in their reviews, either on your site or on sites like Amazon. Lean on your support team and pull language from the actual questions customers ask. Or head to Quora and look at the language people use when talking about similar products. Approaching your description with this mindset will make your product naturally appeal to your customer.',
      image: "assets/images/bag_1_new.jpg",
      color: Colors.brown),
  Product(
      id: 11,
      catQuantity: 1,
      title: 'Bag two',
      price: 234,
      size: 12,
      description: 'hello',
      image: "assets/images/bag_2.jpg",
      color: Colors.teal),
  Product(
      id: 12,
      catQuantity: 1,
      title: 'Bag three',
      price: 234,
      size: 12,
      description: 'hello',
      image: "assets/images/bag_3.jpg",
      color: Colors.orange),
  Product(
      id: 13,
      catQuantity: 1,
      title: 'Bag four',
      price: 234,
      size: 12,
      description: 'hello',
      image: "assets/images/bag_4.jpg",
      color: Colors.deepOrange),
  Product(
      id: 14,
      catQuantity: 1,
      title: 'Bag six',
      price: 234,
      size: 12,
      description: 'hello',
      image: "assets/images/bag_5.jpg",
      color: Colors.purpleAccent),
  Product(
      id: 15,
      catQuantity: 1,
      title: 'Bag seven',
      price: 234,
      size: 12,
      description: 'hello',
      image: "assets/images/bag_6.jpg",
      color: Colors.redAccent),
  Product(
      id: 16,
      catQuantity: 1,
      title: 'Bag eight',
      price: 234,
      size: 12,
      description: 'hello',
      image: "assets/images/bag_7.jpg",
      color: Color(0xFF3D82AE)),
];
