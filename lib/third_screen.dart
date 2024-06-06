import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'fourth_screen.dart';

class ThirdScreen extends StatefulWidget {
  final int? selectedUserIndex;
  final int? selectedPatientIndex;
  final String selectedHospital;
  final String selectedSpeciality; // Menggunakan nama spesialisasi

  ThirdScreen({required this.selectedUserIndex, required this.selectedPatientIndex, required this.selectedHospital, required this.selectedSpeciality, });

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  late List<Map<String, dynamic>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    print('Fetching doctors...');
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/dokters/'));

    if (response.statusCode == 200) {
      print('Doctors fetched successfully.');
      final List<dynamic> responseData = jsonDecode(response.body);

      print('Fetching specialities...');
      final specialitiesResponse = await http.get(Uri.parse('http://127.0.0.1:8000/api/specialitys/'));
      print('Fetching hospitals...');
      final hospitalsResponse = await http.get(Uri.parse('http://127.0.0.1:8000/api/hospitals/'));

      if (specialitiesResponse.statusCode == 200 && hospitalsResponse.statusCode == 200) {
        print('Specialities and hospitals fetched successfully.');
        final List<dynamic> specialitiesData = jsonDecode(specialitiesResponse.body);
        final List<dynamic> hospitalsData = jsonDecode(hospitalsResponse.body);

        setState(() {
          filteredDoctors = responseData
              .where((doctor) {
                // Find corresponding speciality name
                final speciality = specialitiesData.firstWhere(
                  (speciality) => speciality['id_speciality'] == doctor['speciality_id'],
                  orElse: () => null,
                );

                // Find corresponding hospital name
                final hospital = hospitalsData.firstWhere(
                  (hospital) => hospital['id_hospital'] == doctor['hospital_id'],
                  orElse: () => null,
                );

                final specialityName = speciality != null ? speciality['nama_speciality'] : null;
                final hospitalName = hospital != null ? hospital['nama_hospital'] : null;

                print('Doctor: ${doctor['nama_dokter']}, Speciality: $specialityName, Hospital: $hospitalName');

                // Filter based on names instead of IDs
                return specialityName == widget.selectedSpeciality &&
                    hospitalName == widget.selectedHospital;
              })
              .map((doctor) => {
                    'id': doctor['id_dokter'], // Assuming each doctor has an ID
                    'name': doctor['nama_dokter'],
                    'speciality': specialitiesData.firstWhere(
                      (speciality) => speciality['id_speciality'] == doctor['speciality_id'],
                      orElse: () => null,
                    )['nama_speciality'],
                    'hospital': hospitalsData.firstWhere(
                      (hospital) => hospital['id_hospital'] == doctor['hospital_id'],
                      orElse: () => null,
                    )['nama_hospital'],
                    'schedule': doctor['jadwals'], // Assuming there's a schedule field
                  })
              .toList()
              .cast<Map<String, dynamic>>();

          print('Filtered doctors: $filteredDoctors');
        });
      } else {
        print('Failed to fetch specialities or hospitals');
        throw Exception('Failed to load specialities or hospitals');
      }
    } else {
      print('Failed to fetch doctors');
      throw Exception('Failed to load doctors');
    }
  }

  void filterDoctors(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredDoctors = filteredDoctors.where((doctor) =>
            doctor['name'].toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Doctor',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                filterDoctors(value);
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FourthScreen(
                          selectedUserIndex: widget.selectedUserIndex,
                          selectedPatientIndex: widget.selectedPatientIndex,
                          selectedHospital: widget.selectedHospital,
                          selectedSpeciality: widget.selectedSpeciality,
                          doctor: filteredDoctors[index],
                        ),
                      ),
                    );
                  },
                  child: DoctorProfileBox(
                    name: filteredDoctors[index]['name'],
                    speciality: filteredDoctors[index]['speciality'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorProfileBox extends StatelessWidget {
  final String name;
  final String speciality;

  DoctorProfileBox({
    required this.name,
    required this.speciality,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://img.icons8.com/clouds/100/medical-doctor.png',
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            speciality,
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
