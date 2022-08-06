import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // const OrderScreen({ Key? key }) : super(key: key);
  var _isLoading = false;

  // to avoid unnecessary http requests for the FutureBuilder...
  late Future _futureOrders;

  Future _obtainedFutureOrders() {
    return Provider.of<Orders>(context, listen: false).setAndFetchOrders();
  }

  @override
  void initState() {
    _futureOrders = _obtainedFutureOrders();
    super.initState();
  }

  Future<void> refreshOrders(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).setAndFetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderContainer = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshOrders(context),
        child: FutureBuilder(
          future: _futureOrders,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null) {
              return Center(
                child: Text('Error Occured'),
              );
              /*  showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text(
                          'ERROR',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                        content: Text(
                          'Check for your connection please.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 20, color: Colors.redAccent),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(
                              'Okey, I got it',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      )); */
            } else {
              return Consumer<Orders>(
                  builder: ((context, value, child) => ListView.builder(
                        itemCount: orderContainer.orders.length,
                        itemBuilder: (context, index) =>
                            OrderItemWidget(orderContainer.orders[index]),
                      )));
            }
          }),
        ),
      ),
    );
  }
}
