import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc.dart';
import 'main.dart';
import 'patient.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      body: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: OvalTopClipper(),
              child: Container(
                color: Color(0xFF0B8FAC),
                height: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0), // Adjusted padding
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.account_circle,
                            size: 120,
                            color: Color(0xFF0B8FAC),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ), // Added spacing between icon and text
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          auth.username,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: InkWell(
                          onTap: () {
                            // Tindakan yang diambil ketika teks "Edit Pasien" diklik
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientProfilePage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Edit Pasien",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Lanjutkan dengan FractionallySizedBox dan child lainnya
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: InkWell(
                          onTap: () {
                            // Tindakan yang diambil ketika teks "Bahasa" diklik
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Bahasa",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: InkWell(
                          onTap: () {
                            // Tindakan yang diambil ketika teks "Pusat Bantuan" diklik
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Pusat Bantuan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: InkWell(
                          onTap: () {
                            // Tindakan yang diambil ketika teks "Log-Out" diklik
                            Provider.of<Auth>(context, listen: false).logout();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Log-Out",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                            ),
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
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
