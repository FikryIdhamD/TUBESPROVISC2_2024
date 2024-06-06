import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'third_screen.dart';
import 'bloc.dart';

class SecondScreen extends StatefulWidget {
  final int? selectedPatientIndex;
  final int? selectedUserIndex;

  SecondScreen({
    required this.selectedPatientIndex, required this.selectedUserIndex,
  });
  
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String selectedHospital = "";
  String selectedSpeciality = "";

  @override
  Widget build(BuildContext context) {
    final hospitalProvider = Provider.of<HospitalProvider>(context);
    final specialityProvider = Provider.of<SpecialityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Book a new appointment'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Hospitals*",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 14),
              DropdownButton<String>(
                onChanged: (value) {
                  setState(() {
                    selectedHospital = value!;
                  });
                },
                value: selectedHospital.isNotEmpty
                    ? selectedHospital
                    : null, // Ensure the value is null if selectedHospital is empty
                items: [
                  DropdownMenuItem<String>(
                    value: null, // Add a null value item
                    child: Text('Select Hospital'),
                  ),
                  ...hospitalProvider.hospitals
                      .map<DropdownMenuItem<String>>((hospital) {
                    return DropdownMenuItem<String>(
                      value: hospital.name,
                      child: Text(hospital.name),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "All Specialities*",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 14),
              DropdownButton<String>(
                onChanged: (value) {
                  setState(() {
                    selectedSpeciality = value!;
                  });
                },
                value: selectedSpeciality.isNotEmpty
                    ? selectedSpeciality
                    : null, // Ensure the value is null if selectedSpeciality is empty
                items: [
                  DropdownMenuItem<String>(
                    value: null, // Add a null value item
                    child: Text('Select Speciality'),
                  ),
                  ...specialityProvider.specialities
                      .map<DropdownMenuItem<String>>((speciality) {
                    return DropdownMenuItem<String>(
                      value: speciality.name,
                      child: Text(speciality.name),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 164,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: () {
                        // Do something with selectedHospital, selectedSpeciality, and selectedDay
                        print('Selected Hospital: $selectedHospital');
                        print('Selected Speciality: $selectedSpeciality');
                        print('Selected Patient Index: ${widget.selectedPatientIndex}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThirdScreen(
                                selectedUserIndex: widget.selectedUserIndex,
                                selectedPatientIndex: widget.selectedPatientIndex,
                                selectedHospital: selectedHospital,
                                selectedSpeciality: selectedSpeciality),
                          ),
                        );
                      },
                      child: Text("Next"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
