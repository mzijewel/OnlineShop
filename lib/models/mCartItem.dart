import 'package:floor/floor.dart';

@entity
class MCartItem {
  @PrimaryKey()
  int id;
  String image, title, description;
  int price, size, catQuantity;

  MCartItem(
      {this.image,
      this.title,
      this.description,
      this.id,
      this.price,
      this.size,
      this.catQuantity});
}
