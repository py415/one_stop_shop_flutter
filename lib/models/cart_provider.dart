import 'package:flutter/material.dart';

// Blueprint for item in cart.
class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class CartProvider with ChangeNotifier {
  // List of items in cart.
  Map<String, CartItem> _items = {};

  // Get the items in the cart.
  Map<String, CartItem> get items => {..._items};

  // Get the number of items in the cart.
  int get itemCount => _items.length;

  // Get the total cost for all the items in the cart.
  double get totalAmount {
    var total = 0.0;

    // Calculate the total cost of multiple quantity of an item in cart and add it to the cart total.
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  // Add a new item to the cart.
  // Then notify all listeners that item has been updated.
  void addItem(String productId, double price, String title) {
    // Check if item already exists in cart.
    // If so just increment the quantity of item in cart.
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      // If item is not already in cart, then add a single quantity of such item to cart.
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  // Removes all quantity of item (based on productId) from cart.
  // Then notify all listeners that item has been updated.
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Removes a single quantity of item (based on productId) from cart.
  // Then notify all listeners that item has been updated.
  void removeSingleItem(String productId) {
    // Check if cart contains item (based on productId) and if not just return without doing anything.
    if (!_items.containsKey(productId)) {
      return;
    }

    // Checks if item is already in cart and if so then copy the existing cart into a new instance of CartItem widget but with one less quantity (i.e. removes recently added item in the cart).
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1,
            price: null),
      );
    } else {
      // Removes all quantity of item (based on productId) from cart.
      _items.remove(productId);
    }

    notifyListeners();
  }

  // Clear the cart of all items.
  // Then notify all listeners that item has been updated.
  void clear() {
    _items = {};
    notifyListeners();
  }
}
