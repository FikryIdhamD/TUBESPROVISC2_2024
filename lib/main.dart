import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc.dart';
import 'appointments.dart';
import 'records.dart';
import 'login.dart';
import 'Profile.dart';
import 'emergency.dart';
import 'notification.dart';
import 'articles.dart';
import 'first_screen.dart';
import 'package:flutter/gestures.dart';
import 'transactions.dart';
//import 'payment.dart';
import 'Onlineconsultation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your providers here
        ChangeNotifierProvider(create: (_) => ArtikelProvider()..fetchData()),
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProvider(
            create: (_) => HospitalProvider()..fetchHospitals()),
        ChangeNotifierProvider(
            create: (_) => SpecialityProvider()..fetchSpecialities()),
      ],
      child: MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Future<List<List<AppointmentItem>>> fetchDataAndUpdateLists(int userId) async {
  List<AppointmentItem> historyList = [];
  List<AppointmentItem> scheduledList = [];

  try {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/book_appointments/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      // Assuming your API response is a list of appointments in JSON format
      List<dynamic> appointmentsData = jsonData as List<dynamic>;

      for (var appointmentData in appointmentsData) {
        print('Appointment data2: $appointmentData');
        int id = appointmentData['id'];
        int iduser = appointmentData['user_id'];
        int date = appointmentData['jadwal_id'];
        String title;
        int status = appointmentData['status_id'];
        if (status == 6) {
          title = 'Finished Appointment';
        } else {
          title = 'Scheduled Appointment';
        }

        print('id: $id');
        print('iduser: $iduser');
        print('date: $date');
        print('title: $title');
        print('status: $status');

        AppointmentItem item = AppointmentItem(
          id: id,
          iduser: iduser,
          date: date,
          title: title,
          status: status,
          onPressed: () {},
        );

        if (status == 6 && iduser == userId) {
          historyList.add(item);
        } else if (iduser == userId) {
          scheduledList.add(item);
        }
      }

      // Once you've updated the lists, you can use them accordingly
      print('History List: $historyList');
      print('Scheduled List: $scheduledList');

      // Return the updated lists
      return [historyList, scheduledList];
    } else {
      print('Failed to fetch data. Error code: ${response.statusCode}');
      // Return empty lists if fetching data fails
      return [[], []];
    }
  } catch (e) {
    print('Error: $e');
    // Return empty lists if an error occurs
    return [[], []];
  }
}

Future<List<List<RecordsItem>>> fetchMedicalRecords(int IdUser) async {
  List<RecordsItem> MyselfList = [];
  List<RecordsItem> OthersList = [];
  try {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/medical_records/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      int minPasienId = 1000;
      for (var recordData in jsonData) {
        if (recordData['user_id'] == IdUser) {
          if (minPasienId > recordData['pasien_id']) {
            minPasienId = recordData['pasien_id'];
          }
        }
      }

      // Fetching appointments data
      final appointmentsResponse = await http
          .get(Uri.parse('http://127.0.0.1:8000/api/book_appointments/'));
      if (appointmentsResponse.statusCode == 200) {
        final List<dynamic> appointmentsJsonData =
            json.decode(appointmentsResponse.body);

        for (var recordData in jsonData) {
          if (recordData['user_id'] == IdUser) {
            String namaPasien = await fetchPatientName(recordData['pasien_id']);

            // Finding the appointment data corresponding to the medical record
            var appointmentData = appointmentsJsonData.firstWhere(
                (appointment) =>
                    appointment['id'] == recordData['appointment_id'],
                orElse: () => null);
            if (appointmentData != null) {
              String dokterName;
              int dokterSpecialityId;
              String specialityName;
              String jadwalJam;

              // Fetching doctor data
              final doctorResponse = await http
                  .get(Uri.parse('http://127.0.0.1:8000/api/dokters/'));
              if (doctorResponse.statusCode == 200) {
                final List<dynamic> doctorJsonData =
                    json.decode(doctorResponse.body);

                // Finding the doctor based on dokter_id from appointmentData
                var doctorData = doctorJsonData.firstWhere(
                    (doctor) =>
                        doctor['id_dokter'] == appointmentData['dokter_id'],
                    orElse: () => null);
                if (doctorData != null) {
                  dokterName = doctorData['nama_dokter'];
                  dokterSpecialityId = doctorData['speciality_id'];
                  // Fetching speciality data
                  final specialityResponse = await http
                      .get(Uri.parse('http://127.0.0.1:8000/api/specialitys/'));
                  if (specialityResponse.statusCode == 200) {
                    final List<dynamic> specialityJsonData =
                        json.decode(specialityResponse.body);

                    // Finding the speciality based on dokterSpecialityId
                    var specialityData = specialityJsonData.firstWhere(
                        (speciality) =>
                            speciality['id_speciality'] == dokterSpecialityId,
                        orElse: () => null);
                    if (specialityData != null) {
                      specialityName = specialityData['nama_speciality'];
                    } else {
                      print(
                          'Speciality not found for dokterSpecialityId: $dokterSpecialityId');
                      specialityName = 'Unknown';
                    }
                  } else {
                    print(
                        'Failed to load speciality data. Status code: ${specialityResponse.statusCode}');
                    specialityName = 'Unknown';
                  }
                } else {
                  print(
                      'Doctor not found for dokter_id: ${appointmentData['dokter_id']}');
                  continue; // Skip this record if doctor not found
                }

                // Fetching schedule data
                final scheduleResponse = await http
                    .get(Uri.parse('http://127.0.0.1:8000/api/jadwals/'));
                if (scheduleResponse.statusCode == 200) {
                  final List<dynamic> scheduleJsonData =
                      json.decode(scheduleResponse.body);

                  // Finding the schedule based on jadwalId from appointmentData
                  var scheduleData = scheduleJsonData.firstWhere(
                      (schedule) =>
                          schedule['id_jadwal'] == appointmentData['jadwal_id'],
                      orElse: () => null);
                  if (scheduleData != null) {
                    jadwalJam = scheduleData['jam'];
                  } else {
                    print(
                        'Schedule not found for jadwalId: ${appointmentData['jadwal_id']}');
                    jadwalJam = 'Unknown';
                  }
                } else {
                  print(
                      'Failed to load schedule data. Status code: ${scheduleResponse.statusCode}');
                  jadwalJam = 'Unknown';
                }

                String dateTimeString =
                    DateTime.parse(appointmentData['tanggal'])
                        .toString(); // Konversi DateTime menjadi string
                String dateOnly = dateTimeString
                    .split(" ")[0]; // Mengambil bagian tanggal saja

                String dateAndTime =
                    '$dateOnly, $jadwalJam'; // Menggabungkan tanggal dan jam

                RecordsItem medicalRecord = RecordsItem(
                  date: dateAndTime,
                  patient: namaPasien,
                  doctor: dokterName,
                  spesialis: specialityName,
                  onPressed: () {},
                );

                if (recordData['pasien_id'] == minPasienId &&
                    recordData['user_id'] == IdUser) {
                  MyselfList.add(medicalRecord);
                } else if (recordData['user_id'] == IdUser) {
                  OthersList.add(medicalRecord);
                }
              } else {
                print(
                    'Failed to load doctor data. Status code: ${doctorResponse.statusCode}');
              }
            }
          }
        }
      } else {
        print(
            'Failed to load appointments. Status code: ${appointmentsResponse.statusCode}');
        return [];
      }

      print('Medical Records for userId $IdUser: $MyselfList');
      print('Medical Records for userId $IdUser: $OthersList');

      return [MyselfList, OthersList];
    } else {
      print(
          'Failed to load medical records. Status code: ${response.statusCode}');
      return [[], []];
    }
  } catch (e) {
    print('Error fetching medical records: $e');
    return [[], []];
  }
}

Future<String> fetchPatientName(int pasienId) async {
  try {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/pasiens/'));

    if (response.statusCode == 200) {
      final List<dynamic> pasiens = json.decode(response.body);

      // Cari pasien dengan pasienId yang sesuai
      final pasien = pasiens.firstWhere(
        (p) => p['id_pasien'] == pasienId,
        orElse: () => null,
      );

      if (pasien != null) {
        // Ambil nama pasien dari data JSON
        String namaPasien = pasien['nama_pasien'];

        print('Patient name for pasienId $pasienId: $namaPasien');

        return namaPasien;
      } else {
        print('Patient with pasienId $pasienId not found');
        return 'None';
      }
    } else {
      print('Failed to load patient data. Status code: ${response.statusCode}');
      return 'None';
    }
  } catch (e) {
    print('Error fetching patient data: $e');
    return 'None';
  }
}

Future<List<List<TransactionItem>>> fetchTransactions(int userId) async {
  List<TransactionItem> historyList2 = [];
  List<TransactionItem> unpaidList = [];
  try {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/transaksis/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      for (var recordData in jsonData) {
        if (recordData['user_id'] == userId) {
          String title = 'Loading...';
          String status= 'Loading...';

          if(recordData['konsultasi_id'] == 0){
            title = 'Doctor Appointment';
          }else if(recordData['konsultasi_id'] != 0){
            title = 'Online Consultation';
          }
          if(recordData['status_id'] == 2){
            status = 'Payment Completed';
          }else{
            status = 'Payment Incompleted';
          }
          // Fetch appointment details
          final appointmentResponse = await http.get(Uri.parse('http://127.0.0.1:8000/api/book_appointments/${recordData['appointment_id']}'));
          if (appointmentResponse.statusCode == 200) {
            final appointmentData = json.decode(appointmentResponse.body);
            final appointmentDateTime = DateTime.parse(appointmentData['tanggal']); // Assuming the date field exists in the appointment data
            final formattedDate = '${appointmentDateTime.day}-${appointmentDateTime.month}-${appointmentDateTime.year}'; // Format: dd-MM-yyyy

            TransactionItem transaksi = TransactionItem(
              date: formattedDate,
              title: title,
              status: status,
              onPressed: () {},
            );

            if(recordData['status_id'] == 2){
              historyList2.add(transaksi);
            }else{
              unpaidList.add(transaksi);
            }
          } else {
            print('Failed to load appointment details. Status code: ${appointmentResponse.statusCode}');
          }
        }
      }

      print('Transactions for userId $userId: $historyList2');
      print('Transactions for userId $userId: $unpaidList');

      return [historyList2, unpaidList];
    } else {
      print('Failed to load Transactions. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching Transactions: $e');
    return [[], []];
  }
}

class _HomeState extends State<Home> {
  List<AppointmentItem> historyList = []; // Define class-level variables
  List<AppointmentItem> scheduledList = [];
  List<RecordsItem> OthersList = [];
  List<RecordsItem> MyselfList = [];
  List<TransactionItem> historyList2 = [];
  List<TransactionItem> unpaidList = [];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<Auth>(context,
        listen: false); // Use listen: false to prevent unnecessary rebuilds
    fetchDataAndUpdateLists(auth.userId).then((lists) {
      setState(() {
        historyList = lists[0]; // Assign values to class-level variables
        scheduledList = lists[1];
      });
    });
    fetchMedicalRecords(auth.userId).then((lists) {
      setState(() {
        OthersList = lists[1]; // Assign values to class-level variables
        MyselfList = lists[0];
      });
    });
    fetchTransactions(auth.userId).then((lists) {
      setState(() {
        historyList2 = lists[0]; // Assign values to class-level variables
        unpaidList = lists[1];
      });
    });
  }
  // Listarticles articles = Listarticles();

  int _selectedIndex = 0; // untuk penanda tombol bottom navigation

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  String selectedOption1 =
      'History'; // Penanda tombol history dan scheduled Default option is 'History' // Appointment
  String selectedOption2 =
      'Myself'; // Penanda tombol myself dan others Default option is 'myself' // record
  String selectedOption3 =
      'History'; // Penanda tombol history dan unpaid Default option is 'history' // transaction
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    List<Widget> _widgetOptions = <Widget>[
      // Widget untuk halaman Home
      SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                // Banner Image
                Image.asset(
                  'assets/banner.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 50),
                // Adjust the left padding as needed
                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 35.0, // Jarak horizontal antar widget
                    children: [
                      _buildSquareButtonWithText(
                        context,
                        'Book\nAppointment',
                        HomeScreen(selectedUserIndex: auth.userId),
                        'assets/Book-Btn.png',
                      ),

                      _buildSquareButtonWithText(
                        context,
                        'Articles',
                        ArticlePage(),
                        'assets/News-Btn.png',
                      ),

                      // _buildSquareButtonWithText(
                      //     'Lab Tests', 'lab tests page', 'assets/Lab-Btn.png'),
                      _buildSquareButtonWithText(
                        context,
                        'Online\nConsultation',
                        ConsultationScreen(),
                        'assets/Consultation-Btn.png',
                      ),
                    ],
                  ),
                ),

                // Title sebelum gridview artikel
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Latest Article',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12.0),
                // Artikel menggunakan ListView
                Container(
                  height: 160, // Specify a fixed height
                  child: Consumer<ArtikelProvider>(
                    builder: (context, artikelProvider, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: artikelProvider.artikels.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailPage(
                                    article: artikelProvider.artikels[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 250,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(34, 86, 108, 1),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    child: Image.network(
                                      artikelProvider
                                          .artikels[index].fotoArtikel,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          artikelProvider
                                              .artikels[index].titleArtikel,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          artikelProvider
                                              .artikels[index].deskripsiArtikel,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16.0, // Adjust left position as needed
              top: 180.0, // Adjust top position as needed
              child: GestureDetector(
                onTap: () {
                  // Tambahkan fungsi untuk menangani ketika container diklik
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 60.0, // Atur tinggi sesuai kebutuhan Anda
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<Auth>(
                        builder: (context, auth, _) {
                          String hiText =
                              auth.isLoggedIn ? 'Hi, ${auth.username}' : 'Hi,';
                          return RichText(
                            text: TextSpan(
                              text: hiText,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              children: auth.isLoggedIn
                                  ? []
                                  : [
                                      TextSpan(
                                        text: ' Login',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()),
                                            );
                                          },
                                      ),
                                      TextSpan(
                                        text: ' to access more features.',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Emergency()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.local_hospital,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Widget untuk halaman Appointments
      Appointments(
        selectedOption: selectedOption1,
        onOptionChanged: (newOption) {
          setState(() {
            selectedOption1 = newOption;
          });
        },
        appointmentList:
            selectedOption1 == 'History' ? historyList : scheduledList,
      ),

      // Widget untuk halaman Records
      Records(
        selectedOption: selectedOption2,
        onOptionChanged: (newOption) {
          setState(() {
            selectedOption2 = newOption;
          });
        },
        RecordsList: selectedOption2 == 'Myself' ? MyselfList : OthersList,
      ),

      // Widget untuk halaman Transactions
      Transactions(
        selectedOption: selectedOption3,
        onOptionChanged: (newOption) {
          setState(() {
            selectedOption3 = newOption;
          });
        },
        TransactionList:
            selectedOption3 == 'History' ? historyList2 : unpaidList,
      ),
    ];

    return DefaultTextStyle(
      style: GoogleFonts.poppins(), // Set default text style to Poppins
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65.0), // Tinggi header baru
          child: Stack(
            children: [
              // Home Page AppBar
              if (_selectedIndex == 0)
                Container(
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
                    actions: [
                      IconButton(
                        padding: const EdgeInsets.only(right: 10.0),
                        iconSize: 34,
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 20.0),
                        iconSize: 34,
                        icon: const Icon(Icons.account_circle),
                        onPressed: () {
                          // Handle profile button tap
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Profile()));
                        },
                      ),
                    ],
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset(
                          'assets/hospital_logo.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                ),

              // Selected Tab AppBar
              if (_selectedIndex != 0)
                Container(
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
                  child: _buildAppBar(
                    _selectedIndex == 1
                        ? 'Appointments'
                        : _selectedIndex == 2
                            ? 'Medical Records'
                            : _selectedIndex == 3
                                ? 'Transactions'
                                : '',
                  ),
                ),
            ],
          ),
        ),
        body: Column(
          children: [
            if (_selectedIndex == 0) const SizedBox(height: 15.0),
            if (_selectedIndex != 0)
              const SizedBox(
                  height:
                      60.0), // Tambahkan SizedBox di sini dengan tinggi yang diinginkan
            Expanded(
              child: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 5.0,
                offset: const Offset(0.0, -4.0),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Appointments',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: 'Records',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: 'Transactions',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(String title) {
    return AppBar(
      titleSpacing: 25.0,
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30), // Sesuaikan nilai sesuai keinginan Anda
        ),
      ),
      leading: null,
    );
  }
}

Widget _buildSquareButtonWithText(
  BuildContext context,
  String buttonText,
  Widget destinationPage,
  String imagePath,
) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          // Navigate to the specified page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destinationPage,
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            imagePath,
            height: 65,
            width: 65,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 4.0),
      Text(
        buttonText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    ],
  );
}
