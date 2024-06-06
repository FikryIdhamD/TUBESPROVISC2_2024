import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentDetailPage extends StatelessWidget {
  final int appointmentId;

  const AppointmentDetailPage({Key? key, required this.appointmentId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    debugPrint('AppointmentDetailPage - id: $appointmentId');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          padding: const EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(20.0),
              bottomRight: const Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 5.0,
                offset: const Offset(0.0, 4.0),
              ),
            ],
          ),
          child: AppBar(
            toolbarHeight: 70.0,
            titleSpacing: 25.0,
            title: Text(
              'Appointment Detail',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          PreferredSize(
            preferredSize: Size.infinite,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 5.0,
                    offset: const Offset(0.0, 4.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 5.0,
                                offset: const Offset(0.0, 4.0),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://th.bing.com/th/id/OIP.APjmKmC7pAwcvBCbKoxVmgHaGO?w=185&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 6),
                            Text(
                              'Dr. Rajesh Ipsum',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text('Cardiologist',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mereun Hospital Bandung',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          'Jl. Yang Lurus No. 1 Bandung, Jawa Barat',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // COntainer patient details
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Details',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name', style: GoogleFonts.poppins()),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Marvel Ravindra Diop',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('DOB ', style: GoogleFonts.poppins()),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '20 December 2003',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // container Appointment Process
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment Process',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    _buildProcessCircle('Registration', true),
                    Expanded(
                      child: SizedBox(
                        height: 20.0,
                        child: DashedLineWidget(
                          isCompleted: true,
                        ),
                      ),
                    ), // garis putus
                    _buildProcessCircle('Nurse Station', false),
                    Expanded(
                      child: SizedBox(
                        height: 20.0,
                        child: DashedLineWidget(
                          isCompleted: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    _buildProcessCircle('See Doctor', false),
                    SizedBox(
                      width: 2,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 20.0,
                        child: DashedLineWidget(isCompleted: false),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    _buildProcessCircle('Payment', false),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 20.0,
                        child: DashedLineWidget(isCompleted: false),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    _buildProcessCircle('Finished', false),
                  ],
                ),
              ],
            ),
          ),
          // container Appointment Detail
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment Detail',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Cardiology appointment on Thursday, 2 September 2024 at Mereun Hospital Bandung.',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
                ),
                Text(
                  'Scheduled for 18:00',
                  style: GoogleFonts.poppins(),
                ),
                SizedBox(height: 20),
                Center(
                  child: Image.network(
                    'https://img.icons8.com/metro/100/qr-code.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Upon arrival at the hospital, use the provided QR code to confirm your appointment. Scanning the code will automatically place you in the queue and notify you when it\'s your turn.',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          // Row dengan lingkaran berwarna dan tombol cancel appointment
          _buildCircleRow('Scheduled'), // Ganti teks sesuai kebutuhan
        ],
      ),
    );
  }

  Widget _buildCircleRow(String text) {
    Color circleColor = Colors.yellow; // Warna default

    if (text == 'Scheduled') {
      circleColor = Colors.yellow;
    } else if (text == 'Ongoing') {
      circleColor = Colors.green;
    } else if (text == 'Finished') {
      circleColor = Colors.red;
    }

    return Row(
      children: [
        // Lingkaran berwarna
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor, // Gunakan warna yang sudah ditentukan
          ),
        ),
        SizedBox(width: 10), // Jarak antara lingkaran dan teks
        // Text
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14, // Ukuran font
            fontWeight: FontWeight.normal, // Gaya font-weight
          ),
        ),
        // Tombol cancel appointment jika text == Scheduled
        if (text == 'Scheduled') // Spacer agar tombol rata kanan
          Spacer(),
        if (text == 'Scheduled')
          ElevatedButton(
            onPressed: () {
              // Logika untuk membatalkan appointment
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(
                  255, 0, 0, 1), // Memberikan warna merah pada tombol
              padding: EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size(100, 30), // Atur ukuran minimum tombol
            ), // Penyesuaian ukuran tombol,

            child: Text(
              'Cancel Appointment',
              style: GoogleFonts.poppins(
                fontSize: 10, // Ukuran font
                fontWeight: FontWeight.bold,
                color: Colors.white, // Gaya font-weight
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProcessCircle(String label, bool isCompleted) {
    String imageUrl = '';

    // Tentukan URL gambar berdasarkan label
    if (label == 'Registration') {
      imageUrl = 'https://img.icons8.com/clouds/100/edit-user.png';
    } else if (label == 'Nurse Station') {
      imageUrl =
          'https://img.icons8.com/clouds/100/nurse-female.png'; // Ganti dengan URL gambar Nurse Station
    } else if (label == 'See Doctor') {
      imageUrl =
          'https://img.icons8.com/clouds/100/medical-doctor.png'; // Ganti dengan URL gambar Doctor Check
    } else if (label == 'Payment') {
      imageUrl =
          'https://img.icons8.com/clouds/100/card-in-use.png'; // Ganti dengan URL gambar Payment
    } else if (label == 'Finished') {
      imageUrl =
          'https://img.icons8.com/bubbles/50/project-setup.png'; // Ganti dengan URL gambar Finish
    }

    return Column(
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? Colors.green : Colors.grey,
              width: 2.0,
            ),
          ),
          child: Center(
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor:
                  Colors.transparent, // Set background color to transparent
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10),
        ),
      ],
    );
  }
}

class DashedLineWidget extends StatelessWidget {
  final double height;
  final Color color;
  final bool isCompleted;

  const DashedLineWidget({
    Key? key,
    this.height = 1.0,
    this.color = Colors.black,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: CustomPaint(
        painter: DashedLinePainter(color: color, isCompleted: isCompleted),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isCompleted;

  DashedLinePainter({
    required this.color,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isCompleted ? Colors.green : color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final double dashWidth = 5.0;
    final double dashSpace = 2.5;
    double startX = 0.0;

    while (startX < size.width) {
      if (startX + dashWidth <= size.width) {
        canvas.drawLine(
          Offset(startX, 0.0),
          Offset(startX + dashWidth, 0.0),
          paint,
        );
      }
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
