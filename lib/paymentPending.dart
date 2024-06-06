import 'package:flutter/material.dart';
//import 'package:main.dart';
// import 'package:google_fonts/google_fonts.dart';

class paymentPending extends StatefulWidget {
  const paymentPending({super.key});

  @override
  State<paymentPending> createState() => _paymentPendingState();
}

class _paymentPendingState extends State<paymentPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(context),
          buildContent(context),
          Button(context) //konten dibawah stack
        ],
      ),
    );
  }
}

Widget Button(BuildContext context) => Container(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 40),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(double.infinity, 40), // Atur lebar dan tinggi tombol
                  backgroundColor:
                      Color.fromARGB(255, 34, 86, 108), // Your button color
                  foregroundColor: Colors.white,
                ),
                child: Text('Back to home'),
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Home()));
                }),
          ],
        ),
      ),
    );

Widget buildContent(BuildContext context) => Container(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0, left: 30),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/credit_card.png'),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        right:
                            10)), //memberikan jarak antara gambar dan tulisan
                Column(
                  //mengatur ukuran kolom agar sama rata di awal
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Please finish this payment before',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(height: 5),
                    Text('20 April 2024 08:00 PM',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    //richtext digunakan untuk membuat different style pada tulisan yg sama
                    SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Payment Status : ', style: TextStyle()),
                            TextSpan(
                                text: 'PENDING',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 34, 86, 108),
                                    fontWeight: FontWeight.bold)),
                          ]),
                    )
                  ],
                ),
              ],
            ),
            Divider(height: 10, color: Colors.grey),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment ID',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 92, 91, 91))),
                Text('SA-17091812405A15F',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phone Number',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 92, 91, 91))),
                Text('0895 2962 6256',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ],
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Warna shadow
                    spreadRadius: 1, // Radius penyebaran shadow
                    blurRadius: 1, // Besarnya blur pada shadow
                    offset: Offset(0, 5), // Posisi shadow
                  ),
                ],
                borderRadius:
                    BorderRadius.circular(10), // Radius border container
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 70,
                    height: 45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/GOPAY.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(width: 10), // Jarak antara gambar dan teks pertama
                  Text(
                    '628***-****-**56',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 92, 91, 91),
                    ),
                  ),
                  Spacer(), // Spacer untuk mengisi sisa ruang di antara teks pertama dan teks kedua
                  Text(
                    'Unpaid',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 86, 108),
                    ),
                  ),
                  SizedBox(
                      width: 10), // Jarak antara teks kedua dan batas kanan Row
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment Total',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 92, 91, 91))),
                Text('Rp. 999.999',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ],
            ),
          ],
        ),
      ),
    );

Widget buildTop(BuildContext context) {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [buildCoverImage(context), buildTextImage(context)],
  );
}

Widget buildCoverImage(BuildContext context) => Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.5 - 160,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/white_screen.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: MediaQuery.of(context).size.width / 2 -
              50, // Posisi gambar profil dari kiri
          child: Container(
            width: 100,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              // Contoh gambar profil
              image: DecorationImage(
                image: AssetImage(
                    'images/waiting_circle.png'), // Path gambar profil
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );

Widget buildTextImage(BuildContext context) => Center(
      child: Positioned(
        top: MediaQuery.of(context).size.height / 2 -
            95.0, // Atur posisi top dengan mengambil setengah tinggi layar dan mengurangi setengah tinggi widget
        left: MediaQuery.of(context).size.width / 2 -
            137.0, // Atur posisi left dengan mengambil setengah lebar layar dan mengurangi setengah lebar widget
        child: Column(
          children: [
            SizedBox(height: 5),
            Column(
              children: [
                Text('Payment successfully created',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
                Text('Rp. 999.999',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
