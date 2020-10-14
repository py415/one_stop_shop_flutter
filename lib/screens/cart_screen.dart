import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_provider.dart' show CartProvider;
import '../models/orders_provider.dart';
import '../widgets/cart_item.dart';

// Blueprint for cart screen.
class CartScreen extends StatelessWidget {
  // Route name to screen.
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    // Listener of Cart object.
    final cart = Provider.of<CartProvider>(context);

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
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      // Complete cart checkout when user presses "ORDER NOW."
                      // Create a new instance of Order object with the list of items in the cart during checkout.
                      Provider.of<OrdersProvider>(context, listen: false)
                          .addOrder(
                              cart.items.values.toList(), cart.totalAmount);
                      // Clear cart after completion of checkout.
                      cart.clear();
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
