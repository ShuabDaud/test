import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Product _newProduct = Product(
    // id: DateTime.now().toString(),
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  var _isInit = true;
  var _isLoading = false;
  var _initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        final products = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId.toString());
        _newProduct = products;
        // overriding initial values
        _initialValues = {
          'title': _newProduct.title,
          'description': _newProduct.description,
          'price': _newProduct.price.toString(),
          // 'imageUrl': '', // because I am using imageUrlController.
        };
        _imageUrlController.text = _newProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus)
      setState(
          () {}); // for updating image when its Text Form Field loses the focus...
  }

  // saving the form...
  Future<void> _saveForm() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });
        if (_newProduct.id.isNotEmpty) {
          try {
            await Provider.of<ProductsProvider>(context, listen: false)
              .updateProduct(_newProduct.id.toString(), _newProduct);
          } catch (error) {
            await showDialog(
              context: context,
              builder:(ctx) => AlertDialog(
                title: Text('ERROR OCCURED!', style: TextStyle(color: Theme.of(context).errorColor),),
                content: Text('Something went wrong while updating', strutStyle: StrutStyle(fontSize: 18),),
                contentTextStyle: TextStyle(color: Colors.red),
                actions: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Got it!', style: TextStyle(color: Theme.of(context).primaryColor),),),
                ],
              ),
            );
          } 
         
        } else {
          // I am adding a new product...
          try {
            await Provider.of<ProductsProvider>(context, listen: false)
                .addProduct(_newProduct);
          } catch (error) {
            await showDialog<Null>(
                context: context,
                builder: (ctx) => AlertDialog(
                        title: Text(
                          'Error Occured!',
                          style: TextStyle(
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                        content: Text('Something went wrong!'),
                        contentTextStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 18),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text(
                                'Okey',
                                style: TextStyle(fontSize: 14),
                              )),
                        ]));
          } 
          // finally {
          //   setState(() {
          //     _isLoading = false;
          //   });
          //   Navigator.of(context).pop();
          // }
        }
         setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          TextButton(
            onPressed: _saveForm,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (value) {
                        if (value != null) {
                          if (value.isNotEmpty) {
                            _newProduct = Product(
                              id: _newProduct.id,
                              title: value,
                              price: _newProduct.price,
                              description: _newProduct.description,
                              imageUrl: _newProduct.imageUrl,
                              isFavorate: _newProduct.isFavorate,
                            );
                          }
                        }
                      },
                      // validating this input...
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty)
                            return 'Please enter a title value';
                          if (value.length < 3) return 'Invalid title length.';
                        }
                        return null; // no validation error found.
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (val) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) return 'Please enter a value';
                          if (double.tryParse(value) == null)
                            return 'Please enter a valid number';
                          if (double.parse(value) <= 0)
                            return 'Please enter a number greater than 0';
                        }
                        return null; // no validation error found in this field...
                      },
                      onSaved: (value) {
                        if (value != null) {
                          if (value.isNotEmpty) {
                            _newProduct = Product(
                              id: _newProduct.id,
                              isFavorate: _newProduct.isFavorate,
                              title: _newProduct.title,
                              price: double.parse(value),
                              description: _newProduct.description,
                              imageUrl: _newProduct.imageUrl,
                            );
                          }
                        }
                      },
                    ),
                    TextFormField(
                        maxLines: 3,
                        initialValue: _initialValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty)
                              return 'Please enter a description.';
                            if (value.length < 10)
                              return 'Invalid description length.';
                            if (value.length > 100)
                              return 'The description is long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            if (value.isNotEmpty) {
                              _newProduct = Product(
                                id: _newProduct.id,
                                isFavorate: _newProduct.isFavorate,
                                title: _newProduct.title,
                                price: _newProduct.price,
                                description: value,
                                imageUrl: _newProduct.imageUrl,
                              );
                            }
                          }
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text(
                                  'Enter a URL',
                                  textAlign: TextAlign.center,
                                )
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty) return 'Please enter a URL';
                                if (!value.startsWith('https') &&
                                    (!value.startsWith('http')))
                                  return 'Please enter a valid URL';
                                if (!value.endsWith('.png') &&
                                    (!value.endsWith('.jpeg')) &&
                                    (!value.endsWith('.jpg')))
                                  return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) => _saveForm(),
                            onSaved: (value) {
                              if (value != null) {
                                if (value.isNotEmpty) {
                                  _newProduct = Product(
                                    id: _newProduct.id,
                                    isFavorate: _newProduct.isFavorate,
                                    title: _newProduct.title,
                                    price: _newProduct.price,
                                    description: _newProduct.description,
                                    imageUrl: value,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
