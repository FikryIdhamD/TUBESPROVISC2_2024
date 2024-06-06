import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'recordsdetail.dart';

import 'package:google_fonts/google_fonts.dart';

class Records extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionChanged;
  final List<RecordsItem> RecordsList;

  const Records({
    Key? key,
    required this.selectedOption,
    required this.onOptionChanged,
    this.RecordsList = const [], // Default value for RecordsList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget noRecordssWidget = Column(
      children: [
        Image.network(
          'https://img.icons8.com/dotty/80/cancel.png',
          width: 64,
          height: 64,
        ),
        SizedBox(height: 20),
        Text(
          'Book an Records!',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'You dont have any medicalRecords right now',
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
            child: RecordsList.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 200.0),
                    child: Center(child: noRecordssWidget))
                : Column(
                    children: List.generate(
                      RecordsList.length,
                      (index) {
                        // Wrap each RecordsItem with Column and add Divider after it
                        return Column(
                          children: [
                            RecordsList[index],
                            Divider(color: Colors.black), // Horizontal line
                          ],
                        );
                      },
                    )
                        .expand((widget) => [widget, SizedBox(height: 8)])
                        .toList(), // Converts Iterable to List
                  )),
      ],
    );
  }
}

class RecordsItem extends StatelessWidget {
  final String date;
  final String patient;
  final String doctor;
  final String spesialis;
  final VoidCallback onPressed;

  const RecordsItem({
    Key? key,
    required this.date,
    required this.patient,
    required this.doctor,
    required this.spesialis,
    required this.onPressed,
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
                  // Navigate to AppointmentDetailPage when button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecordDetailPage()),
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
