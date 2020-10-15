import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_provider.dart';
import '../models/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

// Blueprint for products overview screen.
class ProductsOverviewScreen extends StatefulWidget {
  // Route name to screen.
  static const String routeName = '/';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // Used to toggle products list in overview screen based on which items were favorited.
  var _showOnlyFavorites = false;
  // Check if product data is fetched from backend database.
  var _isInit = true;
  // Toggle loading HUD when fetching data.
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch products from backend database.
    if (_isInit) {
      // Toggle on loading HUD when fetching data.
      setState(() {
        _isLoading = true;
      });

      // Fetch products from backend database.
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        // Toggle off loading after fetching data finishes.
        setState(() {
          _isLoading = false;
        });
      });
    }

    // Change value to false once data is fetched.
    _isInit = false;
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
          Consumer<CartProvider>(
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavorites: _showOnlyFavorites),
    );
  }
}
