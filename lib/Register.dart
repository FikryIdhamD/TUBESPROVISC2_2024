import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stproject/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fotoController = TextEditingController();

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/users/'), // Replace with your local IP address
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
        'no_telp': _phoneController.text,
        'email': _emailController.text,
        'foto': _fotoController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("User created: $responseData, ${response.body}");

      // Extract user ID from the response
      final userId = responseData['id_user'];

      // Create Pasien for the registered user
      await _createPasien(userId);

      _showAlertDialog('Registration Successful', 'User created successfully.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else if (response.statusCode == 400) {
      print("Account already exists: ${response.body}");
      _showAlertDialog('Registration Failed', 'Account already exists. Proceed to login.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Account Already Exists'),
            content: Text('Do you want to proceed to login?'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      print("Failed to create user: ${response.body}");
      _showAlertDialog('Registration Failed', 'Error: ${response.body}');
    }
  }

  Future<void> _createPasien(int userId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/$userId/pasiens/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_pasien': '1',
        'nik': '',
        'nama_pasien': _usernameController.text,
        'gender': '',
        'alamat': '',
        'tanggal_lahir': '1111-11-11',
        'no_telp': _phoneController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Pasien created: $responseData, ${response.body}");
    } else {
      print("Failed to create pasien: ${response.body}");
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B8FAC),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white, // Warna ikon diubah menjadi putih
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RegisterBody(
        usernameController: _usernameController,
        passwordController: _passwordController,
        phoneController: _phoneController,
        emailController: _emailController,
        fotoController: _fotoController,
        onRegisterPressed: _register,
      ),
    );
  }
}

class RegisterBody extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController fotoController;
  final VoidCallback onRegisterPressed;

  const RegisterBody({
    required this.usernameController,
    required this.passwordController,
    required this.phoneController,
    required this.emailController,
    required this.fotoController,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    'Create your new\naccount',
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
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Create an account to access more features. Fill out the form below to get started',
                            style: TextStyle(color: Colors.black, fontSize: 15),
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
                          TextField(controller: usernameController),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone Number*",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextField(controller: phoneController),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email*",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextField(controller: emailController),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Foto URL",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextField(controller: fotoController),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 33,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: onRegisterPressed,
                        child: Text(
                          "Register",
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
          )
        ],
      ),
    );
  }
}

class OvalTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.6); // Pindahkan titik awal lebih rendah
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.6); // Pindahkan kontrol bezier ke atas
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
