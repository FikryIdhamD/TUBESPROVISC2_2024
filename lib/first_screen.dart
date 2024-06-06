import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'second_screen.dart'; // Import the NextPage
import 'main.dart';
import 'bloc.dart';

class HomeScreen extends StatefulWidget {
  final int? selectedUserIndex;

  HomeScreen({
    required this.selectedUserIndex,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedPatientIndex;
  List<Patient> patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      int userId = auth.userId;
      List<Patient> fetchedPatients = await ApiService.fetchPatients(userId);
      fetchedPatients.sort((a, b) => a.idPasien.compareTo(b.idPasien));
      setState(() {
        patients = fetchedPatients;
        isLoading = false;
      });
      print('Fetched patients: $patients');
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
          ),
          ClipPath(
            clipper: OvalTopClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: Color(0xFF0B8FAC),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double fontSize = constraints.maxWidth * 0.05;
                    return Text(
                      'Pilih Pasien',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 8.0,
            child: IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Home())); // Adjust action accordingly
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0) ...[
                            Text(
                              'MYSELF',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                          ] else if (index == 1) ...[
                            Text(
                              'OTHERS',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                          ContentBox(
                            name: patient.namaPasien,
                            date: patient.tanggalLahir,
                            phoneNumber: patient.noTelp,
                            idPasien: patient.idPasien, // Pass idPasien
                            selectedPatientId:
                                selectedPatientIndex, // Pass selectedPatientId
                            onSelect: (int id) {
                              setState(() {
                                selectedPatientIndex = id;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondScreen(
                            selectedPatientIndex: selectedPatientIndex,
                            selectedUserIndex: widget
                                .selectedUserIndex)), // Adjust destination screen accordingly
                  );
                },
                child: Text(
                  'Next',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContentBox extends StatelessWidget {
  final String name;
  final String date;
  final String phoneNumber;
  final int idPasien;
  final int? selectedPatientId;
  final Function(int)? onSelect;

  const ContentBox({
    Key? key,
    required this.name,
    required this.date,
    required this.phoneNumber,
    required this.idPasien,
    this.selectedPatientId,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onSelect != null) {
          onSelect!(idPasien);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: idPasien == selectedPatientId
              ? Colors.blue[100]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(date),
                  SizedBox(height: 8),
                  Text(phoneNumber),
                ],
              ),
            ),
            Radio(
              value: idPasien == selectedPatientId,
              groupValue: true,
              onChanged: (bool? value) {
                if (onSelect != null) {
                  onSelect!(idPasien);
                }
              },
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
