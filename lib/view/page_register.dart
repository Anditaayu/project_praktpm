import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:project_tpm/view/page_login.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<ScaffoldState> _formKey = GlobalKey<ScaffoldState>();
  bool isPasswordObscured = true;

  final _conUsername = TextEditingController();
  final _conPassword = TextEditingController();

  Future<void> _register() async {
    final username = _conUsername.text.trim();
    final password = _conPassword.text.trim();

    final loginBox = Hive.box('loginBox');
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    if (loginBox.containsKey(username)) {
      // Username already exists
      _showSnackbar('Username already exists');
    } else {
      loginBox.put(username, hashedPassword);
      // Registration successful
      _showSnackbar('Registration Successful');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.only(left: 100, top: 16, right: 100),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(60),
                    child: Text(
                      "Register an account first!",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                      child: Container(
                          padding:
                              EdgeInsets.only(left: 100, top: 16, right: 100),
                          child: Column(children: [
                            TextFormField(
                              controller: _conUsername,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                labelText: 'Username',
                                contentPadding: const EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide:
                                      BorderSide(color: Colors.tealAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _conPassword,
                              obscureText: isPasswordObscured,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                labelText: 'Password',
                                contentPadding: const EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide:
                                      BorderSide(color: Colors.tealAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(isPasswordObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordObscured = !isPasswordObscured;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ]))),
                  Container(
                    padding: EdgeInsets.only(left: 100, top: 16, right: 100),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                      ),
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Does you have account? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          textColor: Colors.teal,
                          child: Text('Login'),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => PageLogin()),
                                (Route<dynamic> route) => false);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
