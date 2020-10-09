import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';

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
          leading: Icon(Icons.receipt),
          title: Text('Orders'),
          onTap: () {
            // Segue into orders history screen when user presses receipt icon.
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
      ]),
    );
  }
}
