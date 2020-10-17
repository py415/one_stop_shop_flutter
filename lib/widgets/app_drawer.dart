import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/user_products_screen.dart';

// Blueprint for AppDrawer widget.
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Hello Friend!'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            // Segue into products overview screen when user presses shop icon.
            Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            // Segue into orders history screen when user presses payment icon.
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () {
            // Segue into user products listing screen when user presses edit icon.
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            // Close drawer.
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            // Logout currently logged in user. Segue back into authentication screen.
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ]),
    );
  }
}
