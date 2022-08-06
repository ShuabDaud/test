import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorate;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorate = false,
  });
  void _setFavValue(bool newFav){
    isFavorate = newFav;
    notifyListeners();
  }
  Future<void> isFavorateToggle() async {
    final oldFav = isFavorate;
    isFavorate = !(isFavorate);
    notifyListeners();
    final url =
        'https://shop-app-29b31-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(
      Uri.parse(url),
      body: json.encode(
        {
          'isFavorate': isFavorate,
        },
      ),
    
    );
    if (response.statusCode >= 400) {
      _setFavValue(oldFav);
    }
    } catch (error) {
      _setFavValue(oldFav);
    }
  }
}
