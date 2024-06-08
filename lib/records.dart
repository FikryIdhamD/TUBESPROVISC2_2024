import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'recordsdetail.dart';
import 'package:google_fonts/google_fonts.dart';

class Records extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionChanged;
  final List<RecordsItem> recordsList;

  const Records({
    Key? key,
    required this.selectedOption,
    required this.onOptionChanged,
    this.recordsList = const [], // Default value for recordsList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget noRecordsWidget = Column(
      children: [
        Image.network(
          'https://img.icons8.com/dotty/80/cancel.png',
          width: 64,
          height: 64,
        ),
        SizedBox(height: 20),
        Text(
          'Book a Record!',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'You don\'t have any medical records right now',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 35.0),
              child: ElevatedButton(
                onPressed: () {
                  onOptionChanged('Myself');
                },
                style: ButtonStyle(
                  backgroundColor: selectedOption == 'Myself'
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 86, 108, 1))
                      : null,
                  foregroundColor: MaterialStateProperty.all<Color>(
                      selectedOption == 'Myself' ? Colors.white : Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(10.0, 25.0)),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: selectedOption == 'Myself'
                          ? Colors.black
                          : Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  'Myself',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 35.0),
              child: ElevatedButton(
                onPressed: () {
                  onOptionChanged('Others');
                },
                style: ButtonStyle(
                  backgroundColor: selectedOption == 'Others'
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 86, 108, 1))
                      : null,
                  foregroundColor: MaterialStateProperty.all<Color>(
                      selectedOption == 'Others' ? Colors.white : Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(10.0, 20.0)),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: selectedOption == 'Others'
                          ? Colors.black
                          : Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  'Others',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10), // Adding space between buttons and list
        Expanded(
          child: recordsList.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: Center(child: noRecordsWidget))
              : Column(
                  children: List.generate(
                    recordsList.length,
                    (index) {
                      // Wrap each RecordsItem with Column and add Divider after it
                      return Column(
                        children: [
                          recordsList[index],
                          Divider(color: Colors.black), // Horizontal line
                        ],
                      );
                    },
                  )
                      .expand((widget) => [widget, SizedBox(height: 8)])
                      .toList(), // Converts Iterable to List
                ),
        ),
      ],
    );
  }
}

class RecordsItem extends StatelessWidget {
  final String date;
  final String patient;
  final String doctor;
  final String spesialis;
  final String contactPasien;
  final String bloodpressure;
  final String weight;
  final String height;
  final String complain;
  final String hasilPemeriksaan;
  final String dokumenPdf;

  const RecordsItem({
    Key? key,
    required this.date,
    required this.patient,
    required this.doctor,
    required this.spesialis,
    required this.contactPasien,
    required this.bloodpressure,
    required this.weight,
    required this.height,
    required this.complain,
    required this.hasilPemeriksaan,
    required this.dokumenPdf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          Text(
            patient,
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                doctor + ', ' + spesialis,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordDetailPage(
                        date: date,
                        patient: patient,
                        doctor: doctor,
                        spesialis: spesialis,
                        contactPasien: contactPasien,
                        bloodpressure: bloodpressure,
                        weight: weight,
                        height: height,
                        complain: complain,
                        hasilPemeriksaan: hasilPemeriksaan,
                        dokumenPdf: dokumenPdf,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(10.0, 20.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                ),
                child: Text(
                  'Detail',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
