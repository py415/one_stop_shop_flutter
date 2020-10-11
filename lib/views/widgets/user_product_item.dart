import 'package:flutter/material.dart';

import '../screens/edit_product_screen.dart';

// Blueprint for user product item widget.
class UserProductItem extends StatelessWidget {
  // Id of user listing item.
  final String id;
  // Title of user listed item.
  final String title;
  // Image URL of user listed item.
  final String imageUrl;

  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                // Delete user product listings when user presses the delete icon.
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
