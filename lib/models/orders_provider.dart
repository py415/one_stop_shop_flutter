import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart_provider.dart';
import '../constants.dart';

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
  List<OrderItem> _orders = [];

  // Get the orders in the order history.
  List<OrderItem> get orders => [..._orders];

  // Fetch orders from backend database.
  // Then notify all listeners that orders have been fetched.
  Future<void> fetchAndSetOrders() async {
    try {
      final response = await http.get(Constants.ordersUrl);
      final loadedOrders = <OrderItem>[];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // Check if there are no orders.
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ));
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // Add a new order after user checks out items from cart.
  // Then notify all listeners that order has been updated (in this case created and added to order list).
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();

    try {
      // Store orders from checkout to backend database.
      final response = await http.post(
        Constants.ordersUrl,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }),
      );

      // After order is stored on backend database, then add order to list of orders.
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );

      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
