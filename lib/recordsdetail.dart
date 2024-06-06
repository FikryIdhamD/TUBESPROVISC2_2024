import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class RecordDetailPage extends StatefulWidget {
  @override
  _RecordDetailPageState createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  bool _showPatientInfo = false;
  bool _showClinicasses = false;

  Future<void> _downloadPdf() async {
    final url =
        'https://drive.google.com/uc?id=1nvB-CeSX4umYS6qvB6pHcw5mzbLnLIcF';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/medical_record.pdf';
        final File file = File(path);
        await file.writeAsBytes(bytes);
        // Jika perlu, tambahkan logika tampilkan pesan notifikasi atau aksi lain setelah selesai unduh.
        print('File berhasil diunduh');
      } else {
        throw Exception(
            'Gagal mengunduh file, kode status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // Tambahkan penanganan kesalahan di sini, seperti menampilkan pesan kesalahan kepada pengguna.
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Medical Record Detail',
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
        padding: EdgeInsets.fromLTRB(16, 25, 16, 16),
        children: [
          // Container for patient information
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Patient Information',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showPatientInfo = !_showPatientInfo;
                        });
                      },
                      child: Icon(
                        _showPatientInfo
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 15),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Contact ', style: GoogleFonts.poppins()),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '+62-8123456789',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_showPatientInfo)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Vital Signs:',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('BP ', style: GoogleFonts.poppins()),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '125/85 mm Hg',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Height ', style: GoogleFonts.poppins()),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '173 cm',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Weight ', style: GoogleFonts.poppins()),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '59 kg',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Container for Clinical Assessments and Observations
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Clinical Assessments and Observations',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showClinicasses = !_showClinicasses;
                        });
                      },
                      child: Icon(
                        _showClinicasses
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date of Consultation ', style: GoogleFonts.poppins()),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '20 May 2023',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cardiologist ', style: GoogleFonts.poppins()),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Dr. Rasmy Humm',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_showClinicasses)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        'Chief Complaint :',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      // Divider(),
                      // SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('[Symptoms/Concerns] ',
                              style: GoogleFonts.poppins()),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Physical Examination:',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      // Divider(),
                      // SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('[Findings]', style: GoogleFonts.poppins()),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Medical History: ',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      // Divider(),
                      // SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('[Brief Overview]',
                              style: GoogleFonts.poppins()),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _downloadPdf, // Panggil fungsi download disini
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(36, 188, 52, 1),
                  minimumSize: Size(120, 40), // Ukuran minimum tombol
                ),
                child: Text(
                  'Download Pdf',
                  style: GoogleFonts.poppins(
                    fontSize: 14, // Ukuran font
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Gaya font-weight
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
