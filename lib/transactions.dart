import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment.dart';
// import 'transactiondetails.dart';

class Transactions extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionChanged;
  final List<TransactionItem> TransactionList;

  const Transactions({
    Key? key,
    required this.selectedOption,
    required this.onOptionChanged,
    this.TransactionList = const [], // Default value for TransactionList
  }) : super(key: key);

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
        SizedBox(
          height: 10,
        ),
        Text(
          selectedOption == 'On going'
              ? 'You have no ongoing Transaction right now'
              : 'You have finished Transaction right now',
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
              padding: EdgeInsets.only(left: 25.0, top: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  onOptionChanged('On going');
                },
                style: ButtonStyle(
                  backgroundColor: selectedOption == 'On going'
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 86, 108, 1))
                      : null,
                  foregroundColor: MaterialStateProperty.all<Color>(
                      selectedOption == 'On going'
                          ? Colors.white
                          : Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(10.0, 20.0)),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: selectedOption == 'On going'
                          ? Colors.black
                          : Colors.black,
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
              child: TransactionList.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 200.0),
                      child: Center(child: noTransactionsWidget))
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          TransactionList.length,
                          (index) {
                            // Wrap each AppointmentItem with Column and add Divider after it
                            return Column(
                              children: [
                                TransactionList[index],
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

class TransactionItem extends StatelessWidget {
  final String date;
  final String title;
  final String status;
  final Function onPressed; // Changed the type to Function

  const TransactionItem({
    Key? key,
    required this.date,
    required this.title,
    required this.status,
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
                  // Call the onPressed function passed from parent
                  onPressed();
                  //Navigate to TransactionDetailPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => paymentMethods()),
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
