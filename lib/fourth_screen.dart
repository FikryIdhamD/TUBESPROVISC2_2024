import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'fifth_screen.dart';

class FourthScreen extends StatefulWidget {
  final int? selectedUserIndex;
  final int? selectedPatientIndex;
  final String selectedHospital;
  final String selectedSpeciality; // Menggunakan nama spesialisasi
  final Map<String, dynamic> doctor;

  FourthScreen(
      {required this.selectedUserIndex,
      required this.selectedPatientIndex,
      required this.selectedHospital,
      required this.selectedSpeciality,
      required this.doctor});

  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  DateTime? _selectedDate; // Use DateTime for selected date
  int? _selectedDayId; // Use int for selected day id

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
                  color: Color(0xFF0B8FAC),
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Doctor Profile',
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.headline6,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.doctor['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.doctor['speciality']),
                              SizedBox(height: 8),
                              Text('Available at ${widget.doctor['hospital']}'),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available Schedule',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              ..._buildScheduleItems(widget.doctor['schedule']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Tanggal:',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _selectedDate = selectedDate;
                                _selectedDayId = _findDayId(selectedDate);
                              });
                            }
                          },
                          child: Text(
                            _selectedDate == null
                                ? 'Pilih Tanggal'
                                : _selectedDate.toString().split(' ')[0],
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _selectedDate != null && _selectedDayId != null
                          ? () async {
                              DateTime selectedDate = _selectedDate!;
                              int day = selectedDate.day;
                              int month = selectedDate.month;
                              int year = selectedDate.year;
                              // Pass necessary data to FifthScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FifthScreen(
                                    selectedUserIndex: widget.selectedUserIndex,
                                    selectedPatientIndex:
                                        widget.selectedPatientIndex,
                                    selectedHospital: widget.selectedHospital,
                                    selectedSpeciality:
                                        widget.selectedSpeciality,
                                    selectedDoctor: widget.doctor,
                                    selectedDate: _selectedDayId!,
                                    selectedDay: day,
                                    selectedMonth: month,
                                    selectedYear: year,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: Text(
                        'Buat Appointment',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
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
    );
  }

  List<Widget> _buildScheduleItems(List<dynamic> schedules) {
    return schedules.map((schedule) {
      return _buildScheduleItem(schedule['hari'], schedule['jam']);
    }).toList();
  }

  Widget _buildScheduleItem(String day, String time) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(day, style: GoogleFonts.poppins()),
            Text(time, style: GoogleFonts.poppins()),
          ],
        ),
      ),
    );
  }

  int? _findDayId(DateTime selectedDate) {
    final selectedDay = DateFormat('EEEE').format(selectedDate);
    final schedule = widget.doctor['schedule'];
    for (final entry in schedule) {
      if (entry['hari'] == selectedDay) {
        return entry['id_jadwal'];
      }
    }
    // If the selected date is not found in the schedule
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content:
              Text('Anda tidak dapat memilih tanggal diluar jadwal dokter.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return null;
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
