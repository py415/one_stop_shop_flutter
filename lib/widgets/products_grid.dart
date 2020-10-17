import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';
import '../providers/products.dart';

// Blueprint for product grid.
class ProductsGrid extends StatelessWidget {
  // Toggle favorited items.
  final bool showFavorites;

  ProductsGrid({this.showFavorites});

  @override
  Widget build(BuildContext context) {
    // Listener for Products.
    final productsData = Provider.of<Products>(context);
    // Set filter based on whether user selected to show favorited items only or all.
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
