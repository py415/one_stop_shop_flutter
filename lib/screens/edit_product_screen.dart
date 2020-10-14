import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/products_provider.dart';

// Blueprint for edit user product screen.
class EditProductScreen extends StatefulWidget {
// Route name to screen.
  static const String routeName = '/edit-product”';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // Used to focus on next text field (i.e. price, description, and imageUrl field in this case).
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  // Controller for image url text field.
  final _imageUrlController = TextEditingController();
  // Used to save the form state.
  final _form = GlobalKey<FormState>();
  // Default variable for product object that will be updated when user enters information in the forms.
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  // Used to check if screen states are the initial values (i.e. empty text fields).
  var _isInit = true;
  // Used to toggle loading HUD.
  var _isLoading = false;
  // Used to check for default or initial text fields (i.e. empty text fields).
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  // Regular expression to check for URL validation.
  final _urlPattern =
      r'(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?';

  @override
  void initState() {
    super.initState();

    // Run updateImageUrl method whenever focus changes.
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        // Fetch user product that is being edited.
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        // Add product listing states to form.
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    // Text fields are no longer empty.
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose of focus nodes to prevent memory leak.
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    // Dispose of controllers to prevent memory leak.
    _imageUrlController.dispose();
  }

  // Updates image preview whenever focus on imageUrlFocusNode is lost (i.e. clicking done or another text field).
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // Check if url provided is valid before previewing it.
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.png'))) {
        return;
      }

      setState(() {});
    }
  }

  // Save data from form.
  void _saveForm() {
    final isValid = _form.currentState.validate();

    // Check if form fields had valid responses.
    if (!isValid) {
      return;
    }

    // Save user input from edit product screen.
    _form.currentState.save();

    // Toggle on loading HUD after clicking save product.
    setState(() {
      _isLoading = true;
    });

    // Check if we are editing product or adding new one.
    if (_editedProduct.id != null) {
      // Update existing product details.
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      // Toggle loading HUD off.
      setState(() {
        _isLoading = false;
      });
      // Navigate back to previous page after updating existing item.
      Navigator.of(context).pop();
    } else {
      // Add new product to list of items.
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        );
      }).then((_) {
        // Toggle loading HUD off.
        setState(() {
          _isLoading = false;
        });
        // Navigate back to previous page after adding new item.
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // Move to next text field (i.e. price below in this case) when user presses next in the keyboard.
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        // Check if user has entered a value in the title text field.
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        // Update title value in default Product variable.
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.datetime,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        // Move to next text field (i.e. description below in this case) when user presses next in the keyboard.
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        // Check if user has entered a value in the price text field.
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }

                        // Check if user entered a valid number.
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }

                        // Check if user entered a number that is greater than 0.
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number that is greater than 0.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        // Update price value in default Product variable.
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        // Check if user has entered a value in the description text field.
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }

                        // Check if users response is at least 10 characters long. Needs to be at least 10 characters long to be valid.
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        // Update description value in default Product variable.
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              // Check if user has entered a value in the image url text field.
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }

                              // Checks if user has entered a valid URL using regular expressions.
                              if (!RegExp(_urlPattern, caseSensitive: false)
                                  .hasMatch(value)) {
                                return 'Please enter a valid URL.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              // Update imageUrl value in default Product variable.
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
