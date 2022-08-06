import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';
import '../models/product.dart';
import '../models/cart.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({ Key? key }) : super(key: key);
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

  // ProductItem(this.id, this.title, this.price, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final singleProduct = Provider.of<Product>(context); //, listen: false
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          header: GridTileBar(
            title: Text(
              singleProduct.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black54,
          ),
          child: GestureDetector(
            /*   onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(title: title),
              ),
            ), */
            onTap: () => Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: singleProduct.id),
            child: Image.network(
              singleProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            title: Text(
              '\$${singleProduct.price}',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            /* using Consumer instead of Provider. the difference is that in
            Provide, you can set listen to false so it never rebuilds*/
            leading: Consumer<Product>(
                builder: (context, value, child) => IconButton(
                      color: Colors.deepOrange,
                      icon: Icon(
                        singleProduct.isFavorate == true
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        // color: Theme.of(context).accentColor,
                        // color: Colors.yellow,
                      ),
                      onPressed: () {
                        singleProduct.isFavorateToggle();
                      },
                    )),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart_sharp,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addCartItem(
                  singleProduct.id.toString(),
                  singleProduct.title,
                  singleProduct.price,
                );
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added to the cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      // to undo remove the item from the cart...
                    cart.removeSingleItem(singleProduct.id.toString());
                    },
                  ),
                ));
              },
            ),
          ),
        ));
  }
}
