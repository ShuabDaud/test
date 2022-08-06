import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_products_item.dart';
import '../screens/edit_product_screen.dart';

class UserPorductsScreen extends StatelessWidget {
  const UserPorductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  // refreshing the products...
  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).setAndFetchData();
  }
  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [IconButton(onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        }, icon: Icon(Icons.add))],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productContainer.items.length,
            itemBuilder: (ctx, index) => UserProductsItem(
                productContainer.items[index].id.toString(),
                  productContainer.items[index].title,
                productContainer.items[index].imageUrl),
          ),
        ),
      ),
    );
  }
}
