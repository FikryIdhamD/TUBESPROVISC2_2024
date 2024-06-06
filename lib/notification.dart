import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ClipPath(
                clipper: OvalTopClipper(),
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Notification',
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.headline6,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "You don't have any notification",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.grey),
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
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

void main() => runApp(MaterialApp(home: NotificationPage()));
