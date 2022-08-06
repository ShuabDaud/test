import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class CartItemWidget extends StatelessWidget {
  // const CartItemWidget({ Key? key }) : super(key: key);
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;

  CartItemWidget({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        }
      },
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) {
           return AlertDialog(
              title: Text('Are You Sure?'),
              content: Text('Do You Want to Delete?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text('YES')),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('NO'),
                ),
              ],
            );
          }),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Padding(
              padding: EdgeInsets.all(2),
              child: FittedBox(
                child: CircleAvatar(
                  radius: 30,
                  child: Text('\$${price.toStringAsFixed(2)}'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('\$${(quantity * price).toStringAsFixed(2)}'),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
