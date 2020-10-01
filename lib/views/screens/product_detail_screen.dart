import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = 'product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Container(),
    );
  }
}
