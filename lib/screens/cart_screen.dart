import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../widgets/cart_item_widget.dart';
import '../models/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartContainer.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText2!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartContainer: cartContainer)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartContainer.items.length,
              itemBuilder: (context, index) => CartItemWidget(
                id: cartContainer.items.values.toList()[index].id,
                title: cartContainer.items.values.toList()[index].title,
                price: cartContainer.items.values.toList()[index].price,
                quantity: cartContainer.items.values.toList()[index].quantity,
                productId: cartContainer.items.keys
                    .toList()[index], // to add key id to let it deleted...
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartContainer,
  }) : super(key: key);

  final Cart cartContainer;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (widget.cartContainer.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrders(
                  widget.cartContainer.items.values.toList(),
                  widget.cartContainer.totalAmount,
                );
                setState(() {
                  _isLoading = false;
                });
                // Navigator.of(context).pushNamed(OrdersScreen.routeName);
                widget.cartContainer.clear();
              },
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Text(
                'ORDER NOW',
                style: TextStyle(color: widget.cartContainer.totalAmount <=0 ? Colors.grey : Theme.of(context).primaryColor),
              ));
  }
}
