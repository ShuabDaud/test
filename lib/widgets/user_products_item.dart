import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductsItem extends StatelessWidget {
  // const UserProductsItem({ Key? key }) : super(key: key);
  final String id;
  final String title;
  final String imageUrl;

  UserProductsItem(
     this.id,
     this.title,
     this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Column(
      children: [
        Card(
          elevation: 5,
          child: ListTile(
            title: Text(title),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // navigate to edit product screen...
                      Navigator.of(context).pushNamed(
                        EditProductScreen.routeName,
                        arguments: id,
                      
                      );
                    },
                    icon: Icon(Icons.edit,
                        size: 25, color: Theme.of(context).primaryColor),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await Provider.of<ProductsProvider>(context, listen: false).removeProduct(id);
                      } catch (error) {
                        scaffold.showSnackBar(
                          SnackBar(content: Text('Could not be deleted!',style: TextStyle(fontSize: 18), textAlign: TextAlign.center,), backgroundColor: Theme.of(context).errorColor,)
                        );
                      }
                    },
                    icon: Icon(Icons.delete,
                        size: 25, color: Theme.of(context).errorColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Divider(),
      ],
    );
  }
}
