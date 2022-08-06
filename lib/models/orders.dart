import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'order_item.dart';
import '../models/cart_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }


  // fetching orders from the server...
  Future<void> setAndFetchOrders() async {
    const url =
        'https://shop-app-29b31-default-rtdb.firebaseio.com/orders.json';
     try {
      final List<OrderItem> loadedOrders = [];
      final response = await http.get(Uri.parse(url));
      final extractedOrders = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedOrders == null) {
        return;
      }
      extractedOrders.forEach((orderId, orderData) {
        loadedOrders.insert(0, OrderItem(
          orderId: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((item) =>
           CartItem(
            id: item['id'],
            title: item['title'],
            price: item['price'],
            quantity: item['quantity'],
          )).toList(),
        ));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // adding items to the top of the list orders...
  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    const url =
        'https://shop-app-29b31-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'dateTime': timestamp.toIso8601String(),
          'amount': total,
          'products': cartProducts
              .map(
                ((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    }),
              )
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          orderId: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
