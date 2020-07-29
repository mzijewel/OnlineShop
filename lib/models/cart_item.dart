import 'package:flutter/foundation.dart';

class CartItem extends ChangeNotifier {
  int cartSize = 0, productQuantity = 0;
  bool isFav = false;

  CartItem({this.cartSize, this.isFav, this.productQuantity});

  updateCartSize(int cartSize) {
    this.cartSize = cartSize;
    notifyListeners();
  }

  updateProductQuantity(int productQuantity) {
    this.productQuantity = productQuantity;
    notifyListeners();
  }

  updateFav(bool isFav) {
    this.isFav = isFav;
    notifyListeners();
  }
}
