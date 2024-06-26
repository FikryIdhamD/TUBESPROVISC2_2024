import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'appoinmentdetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Appointments extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionChanged;
  final List<AppointmentItem> appointmentList;

  const Appointments({
    Key? key,
    required this.selectedOption,
    required this.onOptionChanged,
    this.appointmentList = const [], // Default value for appointmentList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget noAppointmentsWidget = Column(
      children: [
        Image.network(
          'https://img.icons8.com/cotton/64/appointment-time--v2.png',
          width: 64,
          height: 64,
        ),
        SizedBox(height: 20),
        Text(
          'Book an appointment!',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          selectedOption == 'Scheduled'
              ? 'You have no ongoing appointment right now'
              : 'You have finished appointment right now',
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
                  onOptionChanged('History');
                },
                style: ButtonStyle(
                  backgroundColor: selectedOption == 'History'
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 86, 108, 1))
                      : null,
                  foregroundColor: MaterialStateProperty.all<Color>(
                      selectedOption == 'History'
                          ? Colors.white
                          : Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(10.0, 25.0)),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: selectedOption == 'History'
                          ? Colors.black
                          : Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  'History',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 35.0),
              child: ElevatedButton(
                onPressed: () {
                  onOptionChanged('Scheduled');
                },
                style: ButtonStyle(
                  backgroundColor: selectedOption == 'Scheduled'
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 86, 108, 1))
                      : null,
                  foregroundColor: MaterialStateProperty.all<Color>(
                      selectedOption == 'Scheduled'
                          ? Colors.white
                          : Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(10.0, 20.0)),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: selectedOption == 'Scheduled'
                          ? Colors.black
                          : Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  'Scheduled',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10), // Adding space between buttons and list
        Expanded(
          child: Container(
              child: appointmentList.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 200.0),
                      child: Center(child: noAppointmentsWidget))
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          appointmentList.length,
                          (index) {
                            // Wrap each AppointmentItem with Column and add Divider after it
                            return Column(
                              children: [
                                appointmentList[index],
                                Divider(color: Colors.black), // Horizontal line
                              ],
                            );
                          },
                        )
                            .expand((widget) => [widget, SizedBox(height: 8)])
                            .toList(), // Converts Iterable to List
                      ),
                    )),
        ),
      ],
    );
  }
}

class AppointmentItem extends StatefulWidget {
  final int id; // Appointment ID
  final String title;
  final String hari;
  final String jam;
  final String namaStatus;
  final Function onPressed;

  AppointmentItem({
    Key? key,
    required this.id,
    required this.title,
    required this.hari,
    required this.jam,
    required this.namaStatus,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AppointmentItemState createState() => _AppointmentItemState();
}

class _AppointmentItemState extends State<AppointmentItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.hari}, ${widget.jam}',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          Text(
            widget.title,
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.namaStatus ?? 'Loading...',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onPressed();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AppointmentDetailPage(appointmentId: widget.id)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
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
