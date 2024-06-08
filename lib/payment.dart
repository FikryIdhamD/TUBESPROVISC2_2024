import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class paymentMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Detail', // Updated title to "Payment Detail"
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cardiology Appointment', // Updated appointment detail
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildAppointmentDetail(), // Display appointment details
            SizedBox(height: 30),
            _buildPaymentMethod(), // Display payment method dropdown
            SizedBox(height: 30),
            _buildPayNowButton(), // Display Pay Now button
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentDetail() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Doctor: Dr. Rajesh Ipsum',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Appointment Date: Thursday, 2 September 2024',
            style: GoogleFonts.poppins(),
          ),
          SizedBox(height: 10),
          Text(
            'Total Price: Rp.10.000', // Change to the actual total price
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    // List of available payment methods
    List<String> paymentMethods = [
      'GoPay',
      'DANA',
      'OVO',
      'Transfer',
    ];

    // Initial selected payment method
    String selectedPaymentMethod = paymentMethods[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        DropdownButton<String>(
          value: selectedPaymentMethod,
          onChanged: (String? newValue) {
            // Update selected payment method when dropdown value changes
            if (newValue != null) {
              selectedPaymentMethod = newValue;
            }
          },
          items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPayNowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Logic to process payment
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          'Pay Now',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}