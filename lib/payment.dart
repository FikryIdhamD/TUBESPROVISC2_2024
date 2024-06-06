import 'package:flutter/material.dart'; //digunakan untuk mengimport library material dart dari paket flutter yang berguna untuk menyediakan beragam widget untuk membangun antarmuka (UI) aplikasi
//import 'quickalert.dart'; //digunakan untuk menambahkan library quickalert, yang berfungsi menampilkan dialog alert
import 'container_button_model.dart'; //digunakan sebagai widget button
import 'paymentPending.dart';

class paymentMethods extends StatefulWidget {
  // const paymentMethods({super.key});

  @override
  State<paymentMethods> createState() => _paymentMethodsState();
}

class _paymentMethodsState extends State<paymentMethods> {
//Menginisialisasi variabel _type dengan nilai 1 berarti kita mengatur nilai awal atau default dari variabel tersebut. Dalam konteks penggunaan kode di atas, variabel _type digunakan untuk menyimpan nilai yang merepresentasikan pilihan metode pembayaran.

  int _type = 1; //menyimpan nilai dari opsi pembayaran yang dipilih user
  void _handleRadio(Object? e) => setState(() {
        _type = e as int;
      });

//method _handleRadio berparameter e dengan tipe data object (nullable object) digunakan untuk menangani perubahan pada pilihan radio button selama proses pembayaran
//ketika terjadi perubahan pada pilihan radio button maka method setState() akan dipanggil
//nilai parameter e dicasting ke tipe data integer, hal ini karena nilai yg dikirimkan dari pilihan radio button diterima dalam bentuk object

//method ini digunakan dengan tujuan untuk menampilkan notifikasi pembayaran kepada user dalam bentuk dialog
  void showPaymentNotification(BuildContext context) {
    showDialog(
      //memulai proses menampilkan dialog
      context:
          context, //parameter pertama adalah context, yg merupakan konteks widget saat ini
      barrierDismissible:
          false, //mengatur apakah user dapat menutup dialog dengan mengetuk diluar area dialog, dalam kasus ini pengguna tidak dapat menutup dialog secara sembarangan
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Confirmation',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are sure you will make the payment?',
                    style: TextStyle()),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10.0), // Same corner radius
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('Transaction Type'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'Online Consultation (chat)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('Payment Method'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'GOPAY',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment Total'),
                    Text('Rp.999.999',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () =>
                          showAlert(context), // Call showAlert on button press
                      child: Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 34, 86, 108), // Your button color
                        foregroundColor:
                            Colors.white, // Set background color (optional)
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 34, 86, 108), // Your button color
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAlert(context) {
    // QuickAlert.show(
    //     context: context,
    //     title: 'Transaction',
    //     text: 'The transaction was succesful !',
    //     type: QuickAlertType.success);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/Header.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // AppBar Title with transparent background
            Positioned(
              top: 0.0, // Adjust for slight padding from top
              left: 0.0,
              right: 0.0,
              child: AppBar(
                title: Text(
                  'Payment Method',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                leading: BackButton(
                  color: Colors.black,
                ),
                // backgroundColor: Colors.transparent, // Transparent background
                centerTitle: false, // Left-aligned title
                elevation: 4, // Shadow elevation
                shadowColor: Colors.white, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(10.0), // Radius pada sudut kiri bawah
                    bottomRight:
                        Radius.circular(10.0), // Radius pada sudut kanan bawah
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: _type == 1
                        ? Border.all(
                            width: 1, color: Color.fromARGB(255, 34, 86, 108))
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 100),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _type,
                                onChanged: _handleRadio,
                                activeColor: Color.fromARGB(255, 34, 86, 108),
                              ),
                              Text(
                                'DANA',
                                style: _type == 1
                                    ? TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )
                                    : TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                            'https://i.pinimg.com/originals/f5/8c/a3/f58ca3528b238877e9855fcac1daa328.jpg',
                            width: 30,
                            height: 30,
                            fit: BoxFit.fitWidth),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: _type == 2
                        ? Border.all(
                            width: 1, color: Color.fromARGB(255, 34, 86, 108))
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                value: 2,
                                groupValue: _type,
                                onChanged: _handleRadio,
                                activeColor: Color.fromARGB(255, 34, 86, 108),
                              ),
                              Text(
                                'GOPAY',
                                style: _type == 2
                                    ? TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )
                                    : TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                            'https://i.pinimg.com/originals/f5/8c/a3/f58ca3528b238877e9855fcac1daa328.jpg',
                            width: 30,
                            height: 30,
                            fit: BoxFit.fitWidth),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: _type == 3
                        ? Border.all(
                            width: 1, color: Color.fromARGB(255, 34, 86, 108))
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                value: 3,
                                groupValue: _type,
                                onChanged: _handleRadio,
                                activeColor: Color.fromARGB(255, 34, 86, 108),
                              ),
                              Text(
                                'OVO',
                                style: _type == 3
                                    ? TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )
                                    : TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                            'https://i.pinimg.com/originals/f5/8c/a3/f58ca3528b238877e9855fcac1daa328.jpg',
                            width: 30,
                            height: 30),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: _type == 4
                        ? Border.all(
                            width: 1, color: Color.fromARGB(255, 34, 86, 108))
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                value: 4,
                                groupValue: _type,
                                onChanged: _handleRadio,
                                activeColor: Color.fromARGB(255, 34, 86, 108),
                              ),
                              Text(
                                'Shopeepay',
                                style: _type == 4
                                    ? TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )
                                    : TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                            'https://i.pinimg.com/originals/f5/8c/a3/f58ca3528b238877e9855fcac1daa328.jpg',
                            width: 30,
                            height: 30),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sub-Total',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 34, 86, 108)),
                        ),
                        Text(
                          'Rp. 999.000',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 34, 86, 108)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detailed',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 34, 86, 108)),
                        ),
                        Text(
                          'Online Consultation (call)',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 34, 86, 108)),
                        ),
                      ],
                    ),
                    Divider(height: 30, color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 34, 86, 108)),
                        ),
                        Text(
                          'Rp. 999.000',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 34, 86, 108)),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showPaymentNotification(context);
                          },
                          child: Column(
                            children: [
                              ContainerButtonModel(
                                itext: "Confirm Payment",
                                containerWidth: size.width,
                                bgColor: Color.fromARGB(255, 34, 86, 108),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => paymentPending()));
                          },
                          child: Column(
                            children: [
                              ContainerButtonModel(
                                itext: "Payment Detailed",
                                containerWidth: size.width,
                                bgColor: Color.fromARGB(255, 34, 86, 108),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
