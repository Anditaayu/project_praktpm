import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:project_tpm/view/page_home.dart';
import 'package:project_tpm/view/page_register.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool isPasswordObscured = true;
  final TextEditingController _conUsername = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();

  @override
  void dispose() {
    _conUsername.dispose();
    _conPassword.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = _conUsername.text.trim();
    final password = _conPassword.text.trim();

    final loginBox = Hive.box('loginBox');
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    if (loginBox.containsKey(username)) {
      final storedPassword = loginBox.get(username);
      if (hashedPassword == storedPassword) {
        // Login successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Invalid password
        _showSnackbar('Invalid Password');
      }
    } else {
      // Username not found
      _showSnackbar('Username Not Found');
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Login Page"),
          backgroundColor: Colors.teal,
        ),
        body: Column(children: [
          Container(
            padding: EdgeInsets.all(60),
            child: Text(
              "Let's Get Started!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Form(
              child: Container(
                  padding: EdgeInsets.only(left: 100, top: 16, right: 100),
                  child: Column(children: [
                    TextFormField(
                      controller: _conUsername,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Username',
                        contentPadding: const EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
              onPressed: _login,
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Does not have account?',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SignupForm()));
                },
                child: Text('Register'),
                textColor: Colors.teal,
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
