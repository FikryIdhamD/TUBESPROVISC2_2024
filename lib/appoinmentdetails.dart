import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class AppointmentDetailPage extends StatefulWidget {
  final int appointmentId;

  const AppointmentDetailPage({Key? key, required this.appointmentId})
      : super(key: key);

  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  late String doctorName = 'Loading...';
  late String speciality = 'Loading...';
  late String hospitalName = 'Loading...';
  late String hospitalAddress = 'Loading...';
  late String patientName = 'Loading...';
  late String patientDOB = 'Loading...';
  late String hari = 'Loading...';
  late String jam = 'Loading...';
  late DateTime tanggal = DateTime(1111, 11, 11); 
  late int statusId = -1;

  @override
  void initState() {
    super.initState();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    // Fetch all appointments
    final appointmentsResponse = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/book_appointments/'));
    if (appointmentsResponse.statusCode == 200) {
      final List appointmentsData = json.decode(appointmentsResponse.body);
      final appointmentData = appointmentsData.firstWhere(
          (appointment) => appointment['id'] == widget.appointmentId);
      final doctorId = appointmentData['dokter_id'];
      final patientId = appointmentData['pasien_id'];
      final statusId = appointmentData['status_id'];
      final jadwalId = appointmentData['jadwal_id'];
      final tanggal = DateTime.parse(appointmentData['tanggal']);

      setState(() {
        this.statusId = statusId;
        this.tanggal = tanggal;
      });

      // Fetch all jadwals
      final jadwalsResponse =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/jadwals/'));
      if (jadwalsResponse.statusCode == 200) {
        final List jadwalsData = json.decode(jadwalsResponse.body);
        final jadwalData =
            jadwalsData.firstWhere((jadwal) => jadwal['id_jadwal'] == jadwalId);
        final hari = jadwalData['hari'];
        final jam = jadwalData['jam'];

        setState(() {
          this.hari = hari;
          this.jam = jam;
        });
      }

      // Fetch all doctors
      final doctorsResponse =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/dokters/'));
      if (doctorsResponse.statusCode == 200) {
        final List doctorsData = json.decode(doctorsResponse.body);
        final doctorData =
            doctorsData.firstWhere((doctor) => doctor['id_dokter'] == doctorId);
        final doctorName = doctorData['nama_dokter'];
        final specialityId = doctorData['speciality_id'];
        final hospitalId = doctorData['hospital_id'];

        // Fetch hospital data
        final hospitalResponse = await http
            .get(Uri.parse('http://127.0.0.1:8000/api/hospitals/$hospitalId/'));
        if (hospitalResponse.statusCode == 200) {
          final hospitalData = json.decode(hospitalResponse.body);
          final hospitalName = hospitalData['nama_hospital'];
          final hospitalAddress = hospitalData['alamat'];
          setState(() {
            this.hospitalName = hospitalName;
            this.hospitalAddress = hospitalAddress;
          });
        }
        // Fetch all specialities
        final specialitiesResponse =
            await http.get(Uri.parse('http://127.0.0.1:8000/api/specialitys/'));
        if (specialitiesResponse.statusCode == 200) {
          final List specialitiesData = json.decode(specialitiesResponse.body);
          final specialityData = specialitiesData.firstWhere(
              (speciality) => speciality['id_speciality'] == specialityId);
          final specialityName = specialityData['nama_speciality'];
          setState(() {
            this.doctorName = doctorName;
            this.speciality = specialityName;
          });
        }
      }
      final patientsResponse =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/pasiens/'));
      if (patientsResponse.statusCode == 200) {
        final List patientsData = json.decode(patientsResponse.body);
        final patientData = patientsData
            .firstWhere((patient) => patient['id_pasien'] == patientId);
        final patientName = patientData['nama_pasien'];
        final patientDOB = patientData['tanggal_lahir'];

        setState(() {
          this.patientName = patientName;
          this.patientDOB = patientDOB;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AppointmentDetailPage - id: ${widget.appointmentId}');
    debugPrint('Status - id: $statusId');
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildDoctorInfo(),
          SizedBox(height: 20),
          _buildPatientDetails(),
          _buildAppointmentProcess(),
          _buildAppointmentDetail(),
          _buildCircleRow(statusId), // Change text as needed
        ],
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
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
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildImageContainer(
                  'https://th.bing.com/th/id/OIP.APjmKmC7pAwcvBCbKoxVmgHaGO?w=185&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                  50,
                  50,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 6),
                    Text(
                      doctorName,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(speciality,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal, fontSize: 10)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospitalName,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  hospitalAddress,
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
    );
  }

  Widget _buildPatientDetails() {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Details',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildDetailRow('Name', patientName),
          _buildDetailRow('DOB', patientDOB),
        ],
      ),
    );
  }

  Widget _buildAppointmentProcess() {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: _boxDecoration(),
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
              if (statusId == 1) ...[
                _buildProcessCircle('Registration', false),
                _buildDashedLine(false),
                _buildProcessCircle('Nurse Station', false),
                _buildDashedLine(false),
                _buildProcessCircle('See Doctor', false),
                _buildDashedLine(false),
                _buildProcessCircle('Payment', false),
                _buildDashedLine(false),
                _buildProcessCircle('Finished', false),
                _buildDashedLine(false),
              ],
              if (statusId == 2) ...[
                _buildProcessCircle('Registration', true),
                _buildDashedLine(true),
                _buildProcessCircle('Nurse Station', false),
                _buildDashedLine(false),
                _buildProcessCircle('See Doctor', false),
                _buildDashedLine(false),
                _buildProcessCircle('Payment', false),
                _buildDashedLine(false),
                _buildProcessCircle('Finished', false),
                _buildDashedLine(false),
              ],
              if (statusId == 3) ...[
                _buildProcessCircle('Registration', false),
                _buildDashedLine(false),
                _buildProcessCircle('Nurse Station', true),
                _buildDashedLine(true),
                _buildProcessCircle('See Doctor', false),
                _buildDashedLine(false),
                _buildProcessCircle('Payment', false),
                _buildDashedLine(false),
                _buildProcessCircle('Finished', false),
                _buildDashedLine(false),
              ],
              if (statusId == 4) ...[
                _buildProcessCircle('Registration', false),
                _buildDashedLine(false),
                _buildProcessCircle('Nurse Station', false),
                _buildDashedLine(false),
                _buildProcessCircle('See Doctor', true),
                _buildDashedLine(true),
                _buildProcessCircle('Payment', false),
                _buildDashedLine(false),
                _buildProcessCircle('Finished', false),
                _buildDashedLine(false),
              ],
              if (statusId == 5) ...[
                _buildProcessCircle('Registration', false),
                _buildDashedLine(false),
                _buildProcessCircle('Nurse Station', false),
                _buildDashedLine(false),
                _buildProcessCircle('See Doctor', false),
                _buildDashedLine(false),
                _buildProcessCircle('Payment', true),
                _buildDashedLine(true),
                _buildProcessCircle('Finished', false),
                _buildDashedLine(false),
              ],
              if (statusId == 6) ...[
                _buildProcessCircle('Registration', false),
                _buildDashedLine(false),
                _buildProcessCircle('Nurse Station', false),
                _buildDashedLine(false),
                _buildProcessCircle('See Doctor', false),
                _buildDashedLine(false),
                _buildProcessCircle('Payment', false),
                _buildDashedLine(false),
                _buildProcessCircle('Finished', true),
                _buildDashedLine(true),
              ],
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAppointmentDetail() {
  String formattedDate = DateFormat('dd MMMM yyyy').format(tanggal);
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (statusId == 1) // Add this line
            Column(
              // Wrap your children in a Column widget
              children: [
                Text(
                  'Appointment Detail',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Appointment already scheduled for $speciality on $hari, $formattedDate at $hospitalName. Scheduled for $jam',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
                ),
              ],
            ), // Add this line
          if (statusId == 2) // Add this line
            Column(
              // Wrap your children in a Column widget
              children: [
                Text(
                  'Appointment Detail',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '$speciality appointment on $hari, $formattedDate at $hospitalName.',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
                ),
                Text(
                  'Scheduled for $jam',
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
            ), // Add this line
          if (statusId == 3) // Add this line
            Column(
              // Wrap your children in a Column widget
              children: [
                Text(
                  'Appointment Detail',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
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
            ), // Add this line
          if (statusId == 4) // Add this line
            Column(
              // Wrap your children in a Column widget
              children: [
                Text(
                  'Appointment Detail',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
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
            ), // Add this line
          if (statusId == 5) // Add this line
            Column(
              // Wrap your children in a Column widget
              children: [
                Text(
                  'Appointment Detail',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
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
            ), // Add this line
          if (statusId == 6) // Add this line
            Column(
              // Wrap your children in a Column widget
              children: [
                Text(
                  'Appointment Detail',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
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
            ), // Add this line
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 5.0,
          offset: Offset(0.0, 4.0),
        ),
      ],
    );
  }

  Widget _buildImageContainer(String imageUrl, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessCircle(String label, bool isCompleted) {
    String imageUrl = _getImageUrl(label);

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
              backgroundColor: Colors.transparent,
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

  Widget _buildDashedLine(bool isCompleted) {
    return Expanded(
      child: DashedLineWidget(
        height: 2.0,
        color: isCompleted ? Colors.green : Colors.grey,
        isCompleted: isCompleted,
      ),
    );
  }

  String _getImageUrl(String label) {
    switch (label) {
      case 'Registration':
        return 'https://img.icons8.com/clouds/100/edit-user.png';
      case 'Nurse Station':
        return 'https://img.icons8.com/clouds/100/nurse-female.png';
      case 'See Doctor':
        return 'https://img.icons8.com/clouds/100/medical-doctor.png';
      case 'Payment':
        return 'https://img.icons8.com/clouds/100/card-in-use.png';
      case 'Finished':
        return 'https://img.icons8.com/bubbles/50/project-setup.png';
      default:
        return '';
    }
  }

  Widget _buildCircleRow(int statusId) {
    Color circleColor;

    if (statusId == 1) {
      circleColor = Colors.yellow;
    } else if (statusId == 6) {
      circleColor = Colors.red;
    } else {
      circleColor = Colors.green;
    }

    return Row(
      children: [
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
        ),
        SizedBox(width: 10),
        Text(
          statusId == 1
              ? 'Scheduled'
              : statusId == 6
                  ? 'Finished'
                  : 'On Going',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        if (statusId == 1) Spacer(),
        if (statusId == 1)
          ElevatedButton(
            onPressed: () {
              // Logic to cancel appointment
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(255, 0, 0, 1),
              padding: EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size(100, 30),
            ),
            child: Text(
              'Cancel Appointment',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
