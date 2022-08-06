import 'package:flutter/material.dart';

import './cart_item.dart';

class Cart with ChangeNotifier {
  // managing cart item...
  late Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // counting itemes to display on the badge...
  int get itemCount {
    // display per item.
    // return _items.length;

    // display sum of quantity...
    int total = 0;

    _items.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  // displaying sum of quantities...
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  // adding new item to the cart...
  void addCartItem(String productId, String title, double price) {
    // increasing existing item...
    if (_items.containsKey(productId)) {
      ///.... existing ones - changing the quantity...
      _items.update(
          productId,
          (value) => CartItem(
                id: value.id,
                title: value.title,
                price: value.price,
                quantity: value.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  // removing an item...
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // removing single item from the cart...
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (element) => CartItem(
                id: element.id,
                price: element.price,
                quantity: element.quantity - 1,
                title: element.title,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // clearing items in the cart after ordering them...
  void clear() {
    _items = {};
    notifyListeners();
  }
}
