import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_provider.dart';
import '../../models/product.dart';
import '../screens/product_detail_screen.dart';

// Blueprint for product item widget.
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listener of Product object.
    final product = Provider.of<Product>(context, listen: false);
    // Listener of Cart object.
    final cart = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                // Toggle status of favorite of selected item.
                product.toggleFavoriteStatus();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              // Add selected item from overview to cart.
              cart.addItem(product.id, product.price, product.title);

              // Hide existing pop up (incase their is already an existing one showing).
              Scaffold.of(context).hideCurrentSnackBar();
              // Show popup that indicates that the user has pressed and added a new item (or increase quantity of existing item) in the cart.
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      // Remove single quantity of productId from cart.
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
