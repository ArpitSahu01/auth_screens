import 'package:flutter/material.dart';
import 'dart:math';

enum AuthMode {
  Signup,
  Login,
}

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 94),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
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
  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};
  bool _isSignUp = false;
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  void _onSaved() {
    bool validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }

    _form.currentState!.save();
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
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(16),
        height: _authMode == AuthMode.Signup ? 380 : 300,
        width: deviceSize.width * 0.75,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 360 : 300),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email address';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter correct email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value.toString();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 10) {
                      return 'Enter password greater then 10 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value.toString();
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value == null ||
                                value.isEmpty ||
                                _passwordController.text == value)
                              return 'Please enter correct password';
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: _onSaved,
                  child: Text(
                    _authMode == AuthMode.Signup ? 'SIGNUP' : 'LOGIN',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 30, vertical: 4)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.Login
                        ? 'SIGNUP INSTEAD'
                        : 'LOGIN INSTEAD',
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
