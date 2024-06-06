import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stproject/main.dart';

class FifthScreen extends StatefulWidget {
  final int? selectedUserIndex;
  final int? selectedPatientIndex;
  final String? selectedHospital;
  final String? selectedSpeciality;
  final Map<String, dynamic>? selectedDoctor;
  final int? selectedDate;
  final int? selectedDay;
  final int? selectedMonth;
  final int? selectedYear;

  FifthScreen({
    required this.selectedUserIndex,
    required this.selectedPatientIndex,
    required this.selectedHospital,
    required this.selectedSpeciality,
    required this.selectedDoctor,
    required this.selectedDate,
    required this.selectedDay,
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  _FifthScreenState createState() => _FifthScreenState();
}

class _FifthScreenState extends State<FifthScreen> {
  String? hospitalId;
  String? specialityId;
  String? doctorId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIds();
  }

  Future<void> fetchIds() async {
    final fetchedHospitalId = await fetchHospitalId(widget.selectedHospital);
    final fetchedSpecialityId =
        await fetchSpecialityId(widget.selectedSpeciality);
    final fetchedDoctorId = await fetchDoctorId(widget.selectedDoctor);

    setState(() {
      hospitalId = fetchedHospitalId;
      specialityId = fetchedSpecialityId;
      doctorId = fetchedDoctorId;
    });

    // Set _isLoading to false after fetching IDs
    setState(() {
      _isLoading = false;
    });

    // Book appointment after fetching IDs
    await bookAppointment();
  }

  Future<String?> fetchHospitalId(String? hospitalName) async {
    if (hospitalName == null) return "Data not available";
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/hospitals/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final hospital = data.firstWhere(
          (hospital) => hospital['nama_hospital'] == hospitalName,
          orElse: () => null);
      print('Fetched Hospital: $hospital'); // Debug print
      return hospital != null
          ? hospital['id_hospital'].toString()
          : "Data not available";
    } else {
      print('Failed to fetch hospitals with status code: ${response.statusCode}'); // Debug print
      return "Data not available";
    }
  }

  Future<String?> fetchSpecialityId(String? specialityName) async {
    if (specialityName == null) return "Data not available";
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/specialitys/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final speciality = data.firstWhere(
          (speciality) => speciality['nama_speciality'] == specialityName,
          orElse: () => null);
      print('Fetched Speciality: $speciality'); // Debug print
      return speciality != null
          ? speciality['id_speciality'].toString()
          : "Data not available";
    } else {
      print('Failed to fetch specialities with status code: ${response.statusCode}'); // Debug print
      return "Data not available";
    }
  }

  Future<String?> fetchDoctorId(Map<String, dynamic>? doctor) async {
    if (doctor == null || !doctor.containsKey('name'))
      return "Data not available";
    // Check if the doctor already has an ID
    if (doctor.containsKey('id')) {
      return doctor['id'].toString();
    }
    // Fetch from API if ID is not present
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/doctors/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final matchedDoctor = data.firstWhere(
          (doc) => doc['name'] == doctor['name'],
          orElse: () => null);
      print('Fetched Doctor: $matchedDoctor'); // Debug print
      return matchedDoctor != null
          ? matchedDoctor['id'].toString()
          : "Data not available";
    } else {
      print('Failed to fetch doctors with status code: ${response.statusCode}'); // Debug print
      return "Data not available";
    }
  }

 Future<void> bookAppointment() async {
  if (widget.selectedPatientIndex == null ||
      hospitalId == null ||
      doctorId == null ||
      widget.selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Incomplete data, cannot book appointment')));
    return;
  }

  // Format the selected date components into a string in the required format
  String formattedDate =
    "${widget.selectedYear}-${widget.selectedMonth.toString().padLeft(2, '0')}-${widget.selectedDay.toString().padLeft(2, '0')}";

  final appointmentData = {
    'user_id': widget.selectedUserIndex,
    'pasien_id': widget.selectedPatientIndex,
    'hospital_id': int.tryParse(hospitalId!),
    'dokter_id': int.tryParse(doctorId!),
    'jadwal_id': widget.selectedDate,
    'status_id': 1, // Assuming 1 is the default status for a new appointment
    'tanggal': formattedDate, // Include formatted date in the request body
  };
  print('Appointment Data: $appointmentData'); // Debug print

  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/book_appointments/'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(appointmentData),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment booked successfully')));
    // Go back to home after booking appointment
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()),
      (Route<dynamic> route) => false,
    );
  } else {
    print('Failed to book appointment with status code: ${response.statusCode}'); // Debug print
    print('Response body: ${response.body}'); // Debug print
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to book appointment')));
  }
}

   @override
Widget build(BuildContext context) {
  // Loading UI
  return Scaffold(
    body: Stack(
      children: [
        Visibility(
          visible: _isLoading, // Assume _isLoading is a boolean variable
          child: Center(
            child: CircularProgressIndicator(), // Show a loading indicator
          ),
        ),
        Visibility(
          visible: !_isLoading,
          child: Home(), // Show Home() when loading is complete
        ),
      ],
    ),
  );
}
}
