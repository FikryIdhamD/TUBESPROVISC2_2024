import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:stproject/main.dart';
import 'package:stproject/bloc.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Login successful: $responseData, ${response.body}");
      // Update Auth status
      int userId = responseData['user_id'];
      Provider.of<Auth>(context, listen: false).login(_usernameController.text, userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      print("Login failed: ${response.body}");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid username or password. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B8FAC),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LoginPage(
        usernameController: _usernameController,
        passwordController: _passwordController,
        onLoginPressed: _login,
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;

  const LoginPage({
    required this.usernameController,
    required this.passwordController,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: OvalTopClipper(),
              child: Container(
                color: Color(0xFF0B8FAC),
                height: 195,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Enter your account\ninformation',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'To access more features please enter your username and password or ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                            ),
                            TextSpan(
                              text: ' if you don\'t have an account',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Full Name*",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextField(
                              controller: usernameController,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Password*",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: onLoginPressed,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 45),
                            backgroundColor: Color(0xFF0B8FAC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OvalTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
