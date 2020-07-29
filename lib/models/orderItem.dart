class OrderItem {
  OrderItem({
    this.image,
    this.title,
    this.price,
    this.size,
    this.catQuantity,
    this.description,
  });

  String image;
  String title;
  double price;
  double size;
  int catQuantity;
  String description;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    image: json["image"],
    title: json["title"],
    price: json["price"].toDouble(),
    size: json["size"].toDouble(),
    catQuantity: json["catQuantity"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "title": title,
    "price": price,
    "size": size,
    "catQuantity": catQuantity,
    "description": description,
  };
}