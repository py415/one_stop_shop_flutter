import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

// Blueprint for user product item widget.
class UserProductItem extends StatelessWidget {
  // Id of user listing item.
  final String id;
  // Title of user listed item.
  final String title;
  // Image URL of user listed item.
  final String imageUrl;
  // Method to handle product item deletion.
  final Function deleteHandler;

  UserProductItem({this.id, this.title, this.imageUrl, this.deleteHandler});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Edit user product listings when user presses the edit icon.
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  // Delete user product listings when user presses the delete icon.
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      'Deleting product failed!',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
