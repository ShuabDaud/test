import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../models/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0,
                    1
                  ],
                  colors: [
                    Color.fromARGB(255, 176, 41, 229).withOpacity(0.5),
                    Color.fromARGB(255, 206, 68, 68).withOpacity(.9),
                  ]),
            ),
          ),
          SingleChildScrollView(
            // reverse: true,
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-20 * pi / 310)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromARGB(255, 237, 243, 60),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 2),
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      child: Text(
                        'Gas App',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Anton',
                          color:
                          Theme
                              .of(context)
                              .textTheme
                              .headlineSmall!
                              .color,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  // showing errors to the user...
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Ok',
                  style: TextStyle(
                      fontSize: 18, color: Theme
                      .of(context)
                      .primaryColor),
                ),
              ),
            ],
            title: Text(
              'ERROR OCCURRED!',
              style: TextStyle(fontSize: 20, color: Theme
                  .of(context)
                  .errorColor),
            ),
            content: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
              ),
            ),
          ),
    );
  }

  // submitting data...
  Future<void> _submit() async {
    if (_formKey.currentState != null) {
      if (!_formKey.currentState!.validate()) return; // Invalid....
    }
    if (_formKey.currentState != null) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authMode == AuthMode.Signup) {
          await Provider.of<Auth>(context, listen: false).signup(
              _authData['email'] as String, _authData['password'] as String);
        } else {
          await Provider.of<Auth>(context, listen: false).signin(
              _authData['email'].toString(), _authData['password'].toString());
        }
      } on HttpException catch (error) {
        // throw error;
        String errorMessage;
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address exists.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email.';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'The password is too weak.';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'The password is invalid.';
        } else {
          errorMessage = 'Authentication failed!';
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: deviceSize.width * 0.75,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 320 : 260,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            child: Column(
              children: [
                TextFormField(
                  key: ValueKey('E-Mail'),
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid e-mail';
                      }
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    if (newValue != null) {
                      _authData['email'] = newValue;
                    }
                  },
                ),
                TextFormField(
                  key: ValueKey('Password'),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: ((value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 5) {
                          return 'Password is too short';
                        }
                      }
                      return null;
                    }),
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _authData['password'] = newValue;
                      }
                    }),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                  key: ValueKey('Confirm Password'),
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? ((value) {
                      if (value != null) {
                        if (value != _passwordController.text) {
                          return 'Password do not match!';
                        }
                      }
                      return null;
                    })
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      Theme
                          .of(context)
                          .primaryTextTheme
                          .button!
                          .color,
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Theme
                          .of(context)
                          .primaryColor,
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                    ),
                  ),
                ),
                // to switch sign up - login...
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.Login
                          ? 'SIGN UP'
                          : 'LOGIN'} INSTEAD'),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: MaterialStateProperty.all(
                        Theme
                            .of(context)
                            .primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
