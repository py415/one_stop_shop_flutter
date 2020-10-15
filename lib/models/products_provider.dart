import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

// Blueprint for products list widget.
class ProductsProvider with ChangeNotifier {
  // TODO: REMOVE HTTP ENDPOINT URL BEFORE COMMITING TO GITHUB!
  // Http endpoint url for backend database.
  final url = 'ADD_BACKEND_URL_HERE';
  // List of items.
  List<Product> _items = [];

  // Get list of items.
  List<Product> get items => [..._items];

  // Get list of items marked as favorite.
  List<Product> get favoriteItems =>
      _items.where((prodItem) => prodItem.isFavorite).toList();

  // Find item listing by the product id.
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // Fetch products from backend database.
  // Then notify all listeners that products have been fetched.
  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final loadedProducts = <Product>[];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // Add new product into the list of items.
  // Then notify all listeners that a new item has been added.
  Future<void> addProduct(Product product) async {
    try {
      // Store new product to backend database.
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      // After new product is stored on backend database, then add new product to list of items.
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );

      // Add new product to the front of the items list.
      _items.insert(0, newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // Edit existing product listing.
  // Then notify all listeners that a new item has been added.
  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    // Check if product for id currently exist.
    if (prodIndex >= 0) {
      // Product exists, so update state for existing product.
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      // Product for id doesn't exist in product listing.
      print('Error. Product for id does not exist.');
    }
  }

  // Delete existing product listing.
  // Then notify all listeners that a new item has been added.
  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
