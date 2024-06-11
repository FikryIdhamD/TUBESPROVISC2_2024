import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'payment.dart'; // Ensure you have this import if PaymentPage is in another file
import 'transactiondetails.dart';

class Transactions extends StatefulWidget {
  final String selectedOption;
  final Function(String) onOptionChanged;
  final int userId; // Assuming you have a userId to fetch transactions

  const Transactions({
    Key? key,
    required this.selectedOption,
    required this.onOptionChanged,
    required this.userId,
  }) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List<TransactionItem> transactionList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions(widget.userId).then((lists) {
      setState(() {
        if (widget.selectedOption == 'History') {
          transactionList = lists[0];
        } else {
          transactionList = lists[1];
        }
        isLoading = false;
      });
    });
  }

  Future<List<List<TransactionItem>>> fetchTransactions(int userId) async {
    List<TransactionItem> historyList = [];
    List<TransactionItem> unpaidList = [];

    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/transaksis/'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        for (var recordData in jsonData) {
          if (recordData['user_id'] == userId) {
            String title = 'Loading...';
            String status = 'Loading...';
            int appointmentId = recordData['appointment_id'];

            if (recordData['konsultasi_id'] == 0) {
              title = 'Doctor Appointment';
            } else {
              title = 'Online Consultation';
            }
            if (recordData['status_id'] == 2) {
              status = 'Payment Completed';
            } else {
              status = 'Payment Incompleted';
            }

            final appointmentResponse = await http.get(Uri.parse(
                'http://127.0.0.1:8000/api/book_appointments/$appointmentId'));

            if (appointmentResponse.statusCode == 200) {
              final appointmentData = json.decode(appointmentResponse.body);

              if (appointmentData['status_id'] >= 5) {
                final appointmentDateTime =
                    DateTime.parse(appointmentData['tanggal']);
                final formattedDate =
                    '${appointmentDateTime.day}-${appointmentDateTime.month}-${appointmentDateTime.year}';

                TransactionItem transaction = TransactionItem(
                  date: formattedDate,
                  title: title,
                  status: status,
                  appointmentId: appointmentId,
                  onPressed: (int appointmentId) {},
                );

                if (recordData['status_id'] == 2) {
                  historyList.add(transaction);
                } else {
                  unpaidList.add(transaction);
                }
              }
            } else {
              print(
                  'Failed to load appointment details. Status code: ${appointmentResponse.statusCode}');
            }
          }
        }

        return [historyList, unpaidList];
      } else {
        print(
            'Failed to load transactions. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      return [[], []];
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget noTransactionsWidget = Column(
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
        SizedBox(height: 10),
        Text(
          widget.selectedOption == 'On going'
              ? 'You have no ongoing transactions right now'
              : 'You have finished transactions right now',
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
              padding: EdgeInsets.only(left: 25.0, top: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.onOptionChanged('History');
                  fetchTransactions(widget.userId).then((lists) {
                    setState(() {
                      transactionList = lists[0];
                      isLoading = false;
                    });
                  });
                },
                style: ButtonStyle(
                  backgroundColor: widget.selectedOption == 'History'
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 86, 108, 1))
                      : null,
                  foregroundColor: MaterialStateProperty.all<Color>(
                      widget.selectedOption == 'History'
                          ? Colors.white
                          : Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(10.0, 25.0)),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.black,
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
              padding: EdgeInsets.only(left: 25.0, top: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.onOptionChanged('On going');
                  fetchTransactions(widget.userId).then((lists) {
                    setState(() {
                      transactionList = lists[1];
                      isLoading = false;
                    });
                  });
                },
                style: ButtonStyle(
                  backgroundColor: widget.selectedOption == 'On going'
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 86, 108, 1))
                      : null,
                  foregroundColor: MaterialStateProperty.all<Color>(
                      widget.selectedOption == 'On going'
                          ? Colors.white
                          : Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(10.0, 20.0)),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  'On going',
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : transactionList.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 200),
                        child: Center(child: noTransactionsWidget),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            transactionList.length,
                            (index) {
                              return Column(
                                children: [
                                  transactionList[index],
                                  Divider(
                                      color: Colors.black), // Horizontal line
                                ],
                              );
                            },
                          )
                              .expand((widget) => [widget, SizedBox(height: 8)])
                              .toList(), // Converts Iterable to List
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String date;
  final String title;
  final String status;
  final Function(int) onPressed;
  final int appointmentId;

  const TransactionItem({
    Key? key,
    required this.date,
    required this.title,
    required this.status,
    required this.onPressed,
    required this.appointmentId,
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
            title,
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              ElevatedButton(
                onPressed: () {
                  onPressed(appointmentId);
                  if (status == 'Payment Completed') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TransactionDetails(appointmentId: appointmentId),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentMethods(appointmentId: appointmentId),
                      ),
                    );
                  }
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
