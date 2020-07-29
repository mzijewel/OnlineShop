
import 'dart:convert';

import 'package:floor/floor.dart';

MFav favFromJson(String str) => MFav.fromJson(json.decode(str));

String favToJson(MFav data) => json.encode(data.toJson());

@entity
class MFav {
  @primaryKey
  int id;
  String image, title, description;
  int price, size, catQuantity;

  MFav(
      {this.image,
      this.title,
      this.description,
      this.id,
      this.price,
      this.size,
      this.catQuantity});

  factory MFav.fromJson(Map<String, dynamic> json) => MFav(
    id: json["id"],
    image: json["image"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    size: json["size"],
    catQuantity: json["catQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "title": title,
    "description": description,
    "price": price,
    "size": size,
    "catQuantity": catQuantity,
  };
}
