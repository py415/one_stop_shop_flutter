import 'package:flutter/material.dart';

import 'cart_provider.dart';

// Blueprint for order checked out from cart.
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  // List of previously checked out orders.
  final List<OrderItem> _orders = [];

  // Get the orders in the order history.
  List<OrderItem> get orders => [..._orders];

  // Add a new order after user checks out items from cart.
  // Then notify all listeners that order has been updated (in this case created and added to order list).
  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
