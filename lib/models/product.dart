import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

// Blueprint for product.
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    // If network request fails or an error occurs, change back to initial favorite status.
    isFavorite = newValue;
    notifyListeners();
  }

  // Toggle status of favorite for product.
  // Then notify all listeners that item has been updated.
  Future<void> toggleFavoriteStatus() async {
    final url = Constants.fetchProduct(id);
    final oldStatus = !isFavorite;

    // Toggle item as favorite.
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      // Update favorite status on backend database.
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );

      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
      print(error);
      rethrow;
    }
  }
}
