import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders_provider.dart' show OrdersProvider;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

// Blueprint for order screen.
class OrdersScreen extends StatelessWidget {
  // Route name to screen.
  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // Listener of Orders object.
    final orderData = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(
          order: orderData.orders[i],
        ),
      ),
    );
  }
}
