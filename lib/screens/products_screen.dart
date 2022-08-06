import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../widgets/badge.dart';
import '../widgets/widgets.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../models/products_provider.dart';

enum FilterOptions { Favorites, All }

class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // const ProductScreen({Key? key}) : super(key: key);
  var _showFavoritesOnly = false;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .setAndFetchData()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

/*   @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ProductsProvider>(context).setAndFetchData();
    });
    super.initState();
  } */
  /*  @override
  void didChangeDependencies() {
    Provider.of<ProductsProvider>(context).setAndFetchData();
    super.didChangeDependencies();
  } */
  @override
  Widget build(BuildContext context) {
    // final cartContainer = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  // print(selectedValue);
                  if (selectedValue == FilterOptions.Favorites) {
                    // ...
                    // productContainer.showFavs();
                    _showFavoritesOnly = true;
                  } else {
                    // ...
                    // productContainer.showAll();
                    _showFavoritesOnly = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (context, value, child) => Badge(
              child: child!,
              value: value.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body:  _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :
          ProductsGrid(_showFavoritesOnly),
    );
  }
}
