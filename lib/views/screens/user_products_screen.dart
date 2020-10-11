import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';
import '../../models/products_provider.dart';
import '../../views/widgets/app_drawer.dart';
import '../../views/widgets/user_product_item.dart';

// Blueprint for user products screen.
class UserProductsScreen extends StatelessWidget {
  // Route name to screen.
  static const String routeName = '/user-products”';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Segue into edit product screen.
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                id: productsData.items[i].id,
                title: productsData.items[i].title,
                imageUrl: productsData.items[i].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
