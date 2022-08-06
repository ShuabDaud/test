import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';

import 'product_item_widget.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    // to make it short and concise...
    final products =
        showFavs == true ? productsData.filteredItems : productsData.items;
    return GridView.builder(
        padding: EdgeInsets.all(8),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          // childAspectRatio: 2 / 2,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(
                  // products[index].id,
                  // products[index].title,
                  // products[index].price,
                  // products[index].imageUrl,
                  ),
            ));
  }
}
