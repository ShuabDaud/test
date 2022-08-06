import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  // late String token;
  // late String _userId;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
/*     Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];

  // var _showFavsOnly = false;

  List<Product> get filteredItems {
    return _items.where((element) => element.isFavorate).toList();
  }

  // to fetch items since they are private (_items).
  List<Product> get items {
    /*  if (_showFavsOnly) {
      return _items.where((element) => element.isFavorate).toList();
    } */
    return [..._items];
  }
  // show favs...
  /* void showFavs() {
    _showFavsOnly = true;
    notifyListeners();
  }
  // show all...
  void showAll() {
    _showFavsOnly = false;
    notifyListeners();
  } */

  // void update(String token) {
  //   token = token;
  //   // _userId = userId;
  //   notifyListeners();
  // }

  // finds products by id...
  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
  // add token property to load the products after loging in or signing up.
  final String authToken;
  ProductsProvider(this.authToken, this._items);
  // this method adds new product to the list...
  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-29b31-default-rtdb.firebaseio.com/products.json?token=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'desription': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorate': product.isFavorate,
          }));

      print(json.decode(response.body));
      final _newProd = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      // print('id is: ${product.id}');
      _items.add(_newProd);
      notifyListeners();
    } catch (error) {
      print('This is the error you have! $error');
      throw error;
    }
  }

  // fetching data from the server...
  Future<void> setAndFetchData() async {
    const url =
        'https://shop-app-29b31-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));
      // extracted data from the server...
      final Map<dynamic, dynamic>? extractedProductData =
          json.decode(response.body);
      // temporary list which is empty...
      final List<Product> loadedProductData = [];
      if (extractedProductData == null) {
        return;
      }
      extractedProductData.forEach((prodId, prodData) {
        loadedProductData.add(
          Product(
            id: prodId,
            title: prodData['title'],
            price: prodData['price'],
            description: prodData['desription'],
            imageUrl: prodData['imageUrl'],
            isFavorate: prodData['isFavorate'],
          ),
        );
      });

      _items = loadedProductData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // updating an existing data...
  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-29b31-default-rtdb.firebaseio.com/products/$id.json';
      try {
        await http.patch(
          Uri.parse(url),
          body: json.encode(
            {
              'title': newProduct.title,
              'price': newProduct.price,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
            },
          ),
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  // deleting products from the list...
  Future<void> removeProduct(String id) async {
    final url = 'ht://shop-app-29b31-default-rtdb.firebaseio.com/products/$id.json';
    // final existingProduct = _items.firstWhere((element) => element.id == id);
    final existingProductIndex = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);// rollback by optimistic pattern for deleting something while something went wrong...
      notifyListeners();
      throw HttpException('Could not be deleted.');
    }
    // _items.removeWhere((element) => element.id == id);
  }
}
