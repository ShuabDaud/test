import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: Text('Orders'),
            leading: Icon(
              Icons.payment,
              size: 40,
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            title: Text('Shop Now'),
            leading: Icon(
              Icons.shop,
              size: 40,
            ),
            onTap: () => Navigator.of(context).pushNamed('/'),
          ),
          Divider(),
          ListTile(
            title: Text('Manage Products'),
            leading: Icon(
              Icons.edit,
              size: 40,
            ),
            onTap: () =>
                Navigator.of(context).pushNamed(UserPorductsScreen.routeName),
          )
        ],
      ),
    );
  }
}
