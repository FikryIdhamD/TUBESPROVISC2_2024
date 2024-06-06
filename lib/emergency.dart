import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Emergency extends StatefulWidget {
  const Emergency({super.key});

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
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
      body: EmergencyPage(),
    );
  }
}

class EmergencyPage extends StatelessWidget {
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
                height: 140,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      'Emergency',
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
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
                          "Medical Emergency",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Get emergency medical assistance from Mereun Hospital nearby.',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Tindakan yang diambil ketika seluruh container diklik
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20), // Menambahkan padding
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.phone_in_talk,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Call Us",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Text(
                                            "+1-234-567", // Nomor telepon Anda
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Call Now",
                                          style: TextStyle(
                                            color: Colors
                                                .white, // Mengatur warna teks menjadi putih
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors
                                              .red, // Menentukan warna latar belakang tombol
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Nearest Hospital',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            // Lanjutkan dengan FractionallySizedBox dan child lainnya
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: InkWell(
                                onTap: () {
                                  // Tindakan yang diambil ketika teks "Bahasa" diklik
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15), // Ubah padding di sini
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Mereun Hospital Bandung",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Jl. Yang Lurus No. 1 Bandung, Jawa Barat", // Nomor telepon Anda
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15,), // SizedBox untuk jarak antara container dan teks berikutnya
                                      Container(
                                        alignment: Alignment
                                            .centerRight, // Untuk mengatur posisi ke kanan
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        padding: EdgeInsets.only(
                                          right:
                                              15, // Mengubah padding di sini untuk membuat ruang di sebelah kiri
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize
                                              .min, // Mengatur ukuran row agar sesuai dengan konten
                                          children: [
                                            Text(
                                              "Directions",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    5), // Memberikan sedikit ruang antara teks dan ikon
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ],
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
