import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'http_exception.dart';
import '../constants.dart';
import 'product.dart';

// Blueprint for products list widget.
class ProductsProvider with ChangeNotifier {
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
      final response = await http.get(Constants.productsUrl);
      final loadedProducts = <Product>[];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // Check if there are no products.
      if (extractedData == null) {
        return;
      }

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
        Constants.productsUrl,
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
  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    // Check if product for id currently exist.
    if (prodIndex >= 0) {
      final url = Constants.fetchProduct(id);

      // Update item for product with id.
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );

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
  Future<void> deleteProduct(String id) async {
    final url = Constants.fetchProduct(id);
    // Index for product selected with id.
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    // Product for selected item.
    var existingProduct = _items[existingProductIndex];
    // Delete product from backend database.
    final response = await http.delete(url);

    // Remove product from items list.
    _items.removeAt(existingProductIndex);
    notifyListeners();

    if (response.statusCode >= 400) {
      // Reinsert product to list in case deleting fails.
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Error. Could not delete product.');
    }

    // Set to null if successfully deleted product from backend database.
    existingProduct = null;
  }
}
