import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TransactionDetails extends StatefulWidget {
  final int appointmentId;

  TransactionDetails({required this.appointmentId});

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  late String doctorName = 'Loading...';
  late String speciality = 'Loading...';
  late String hospitalName = 'Loading...';
  late String hospitalAddress = 'Loading...';
  late String patientName = 'Loading...';
  late String patientDOB = 'Loading...';
  late String hari = 'Loading...';
  late String jam = 'Loading...';
  late DateTime tanggal = DateTime(1111, 11, 11);
  late int userId = -1;
  late int doctorId = -1;
  late int patientId = -1;
  late int jadwalId = -1;
  late int statusId = -1;
  late int hospitalId = -1;
  late int medicalId = -1;
  late String bloodpressure = 'Loading...';
  late String tinggi_badan = 'Loading...';
  late String berat_badan = 'Loading...';
  late String complain = 'Loading...';
  late String hasil_pemeriksaan = 'Loading...';
  late String riwayat_medis = 'Loading...';
  late String dokumen_pdf = 'Loading...';
  late int transaksiId = -1;

  // Selected payment method
  late String selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    fetchAppointmentDetails(widget.appointmentId);
    fetchTransaction(widget.appointmentId);
  }

  Future<void> fetchAppointmentDetails(int appointmentId) async {
    // Fetch all appointments
    final appointmentsResponse = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/book_appointments/'));
    if (appointmentsResponse.statusCode == 200) {
      final List appointmentsData = json.decode(appointmentsResponse.body);
      final appointmentData = appointmentsData
          .firstWhere((appointment) => appointment['id'] == appointmentId);
      final userId = appointmentData['user_id'];
      final doctorId = appointmentData['dokter_id'];
      final patientId = appointmentData['pasien_id'];
      final statusId = appointmentData['status_id'];
      final jadwalId = appointmentData['jadwal_id'];
      final hospitalId = appointmentData['hospital_id'];
      final tanggal = DateTime.parse(appointmentData['tanggal']);

      setState(() {
        this.userId = userId;
        this.doctorId = doctorId;
        this.patientId = patientId;
        this.jadwalId = jadwalId;
        this.statusId = statusId;
        this.hospitalId = hospitalId;
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

  Future<void> updateStatus() async {
    final url = Uri.parse(
        'http://127.0.0.1:8000/api/book_appointments/${widget.appointmentId}');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "status_id": 6,
        "user_id": userId,
        "pasien_id": patientId,
        "hospital_id": hospitalId,
        "dokter_id": doctorId,
        "jadwal_id": jadwalId,
      }),
    );

    if (response.statusCode == 200) {
      print('Berhasil update status');
    } else {
      print('Failed to update status. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> fetchTransaction(int appointmentId) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/transaksis/'),
    );

    if (response.statusCode == 200) {
      final List trasaksis = json.decode(response.body);
      final transaksi = trasaksis.firstWhere(
          (transaksi) => transaksi['appointment_id'] == appointmentId);
      setState(() {
        this.transaksiId = transaksi['id_transaksi'];
      });
    } else {
      throw Exception('Failed to fetch transaction');
    }
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  Widget _buildDoctorInfo() {
    String formattedDate = DateFormat('dd MMMM yyyy').format(tanggal);
    return Container(
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Date of Consultation', hari + ', $formattedDate'),
            _buildDetailRow('Doctor', doctorName),
            _buildDetailRow('Speciality', speciality),
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

  Widget _buildTransactionDetails() {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Transaction Details',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          _buildDetailRow('Consultation fee', 'Rp 333.333'),
          _buildDetailRow('Laboratory Tests', 'Rp 333.333'),
          _buildDetailRow('Medications', 'Rp 333.333'),
          Divider(
            color: Color.fromARGB(255, 0, 0, 0), // Divider color
            thickness: 1, // Divider thickness
          ),
          _buildDetailRow('Total', 'Rp 999.999', bold: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorInfo(),
            SizedBox(height: 20),
            _buildPatientDetails(),
            _buildTransactionDetails(),
          ],
        ),
      ),
    );
  }
}
