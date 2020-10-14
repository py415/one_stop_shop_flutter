import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';

// Blueprint for product details screen.
class ProductDetailScreen extends StatelessWidget {
  // Route name to screen.
  static const String routeName = '/details';

  @override
  Widget build(BuildContext context) {
    // Product id of selected item from previous screen (selectd item from overview screen).
    final productId = ModalRoute.of(context).settings.arguments as String;
    // Listener for Products list object.
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
