import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // ProductDetailScreen({ Key? key, required this.title }) : super(key: key);
  // final String title;
  

  // creating a rout for this screen.
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    // final productId =  ModalRoute.of(context)!.settings.arguments as String;
    // final loadedProducts = Provider.of<ProductsProvider>(context).items.firstWhere((pro) => pro.id == productId);
    final productID = ModalRoute.of(context)!.settings.arguments as String;
    
    final loadedProducts =
        Provider.of<ProductsProvider>(context).findById(productID);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProducts.title),
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(
                loadedProducts.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProducts.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              loadedProducts.description,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(fontSize: 17),
            )
          ],
        ),
      ),
    );
  }
}
