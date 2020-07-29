import 'package:floor/floor.dart';

@entity
class MOrderItem {
  @PrimaryKey(autoGenerate: true)
  int id;
  int parenId;
  String image, title, description;
  int price, size, catQuantity;

  MOrderItem(
      {this.image,
      this.title,
      this.description,
      this.id,
      this.price,
      this.size,
      this.catQuantity});
}
