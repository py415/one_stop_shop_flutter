import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

// Blueprint for products overview screen.
class ProductsOverviewScreen extends StatefulWidget {
  // Route name to screen.
  static const String routeName = '/products';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // Used to toggle products list in overview screen based on which items were favorited.
  var _showOnlyFavorites = false;
  Future _productsFuture;

  Future runFuture() async {
    return await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  void initState() {
    super.initState();

    // Fetch products data.
    _productsFuture = runFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('One Stop Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedFilter) {
              setState(() {
                // If user filters overview by favorited.
                if (selectedFilter == FilterOptions.Favorites) {
                  // Toggle to show only favorited products.
                  _showOnlyFavorites = true;
                } else {
                  // Toggle to show all items.
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Segue into cart when user taps on shopping cart icon in the navigation bar.
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              // ...
              // Handle data snapshot error
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Products>(
                builder: (ctx, productData, child) =>
                    ProductsGrid(showFavorites: _showOnlyFavorites),
              );
            }
          }
        },
      ),
    );
  }
}
