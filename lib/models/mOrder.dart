import 'package:floor/floor.dart';

@entity
class MOrder {
  MOrder({
    this.id,
    this.numberOfProduct,
    this.totalPrice,
    this.orderStatus,
    this.orderDate,
  });

  @primaryKey
  int id;
  int numberOfProduct;
  double totalPrice;
  String orderStatus;
  String orderDate;
}
