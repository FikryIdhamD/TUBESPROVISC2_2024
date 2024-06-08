import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc.dart';
import 'addpatientpage.dart';

class PatientProfilePage extends StatefulWidget {
  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  List<Patient> patients = []; // Perbarui variabel patients
  List<Patient> myselfPatients = [];
  List<Patient> othersPatients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      int userId = auth.userId;
      List<Patient> fetchedPatients = await ApiService.fetchPatients(userId);
      setState(() {
        patients = fetchedPatients;
        _groupPatients();
      });
    } catch (e) {
      print('Error loading patients: $e');
      // Handle error loading patients
    }
  }

  void _groupPatients() {
    int smallestId = patients.isNotEmpty
        ? patients
            .map((e) => e.idPasien)
            .reduce((min, value) => min < value ? min : value)
        : 0;
    myselfPatients.clear();
    othersPatients.clear();
    for (var patient in patients) {
      if (patient.idPasien == smallestId) {
        myselfPatients.add(patient);
      } else {
        othersPatients.add(patient);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Patient Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  if (myselfPatients.isNotEmpty) ...[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Myself:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (var patient in myselfPatients)
                      _buildPatientContainer(patient, isMyself: true),
                  ],
                  if (othersPatients.isNotEmpty) ...[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Others:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (var patient in othersPatients)
                      _buildPatientContainer(patient),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _addPatient();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0B8FAC),
                      ),
                      child: Text(
                        'Add Other Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientContainer(Patient patient, {bool isMyself = false}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${patient.namaPasien}' + (isMyself ? ' - Myself' : ''),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    child: Text('Edit'),
                    value: 'edit',
                  ),
                  const PopupMenuItem(
                    child: Text('Delete'),
                    value: 'delete',
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _editPatient(patient);
                  } else if (value == 'delete') {
                    _deletePatient(patient);
                  }
                },
              ),
            ],
          ),
          Text('${patient.tanggalLahir}'),
          Text('${patient.noTelp}'),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              _requestChangeData(patient);
            },
            child: Text(
              'Request Change Data',
              style: TextStyle(
                color: Colors.black54,
                decoration: TextDecoration.underline,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addPatient() {
    final auth = Provider.of<Auth>(context, listen: false);
    int userId = auth.userId;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPatientPage(userId: userId)),
    );
  }

  void _requestChangeData(Patient patient) {
    print('Requesting change data...');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChangeDataPage(
                patient: patient,
                userId: 'userId',
              )),
    );
  }

  void _editPatient(Patient patient) {
    print('Editing patient: ${patient.namaPasien}');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChangeDataPage(
                patient: patient,
                userId: '',
              )),
    );
  }

  void _deletePatient(Patient patient) {
    print('Deleting patient: ${patient.namaPasien}');
    setState(() {
      patients.remove(patient);
      _groupPatients();
    });
  }
}

class ChangeDataPage extends StatefulWidget {
  final Patient patient;
  final String userId;

  ChangeDataPage({required this.patient, required this.userId});

  @override
  _ChangeDataPageState createState() => _ChangeDataPageState();
}

class _ChangeDataPageState extends State<ChangeDataPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nikController;
  late TextEditingController _namaPasienController;
  late TextEditingController _alamatController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _noTelpController;

  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    _nikController = TextEditingController(text: widget.patient.nik);
    _namaPasienController =
        TextEditingController(text: widget.patient.namaPasien);
    _alamatController = TextEditingController(text: widget.patient.alamat);
    _tanggalLahirController =
        TextEditingController(text: widget.patient.tanggalLahir);
    _noTelpController = TextEditingController(text: widget.patient.noTelp);
    _selectedGender = widget.patient.gender?.isNotEmpty == true
        ? widget.patient.gender
        : 'Laki-laki'; // Initialize the gender with a default value if null or empty
  }

  Future<void> _updatePatientData() async {
    final patientId = widget.patient.idPasien;

    // Format tanggal sebelum mengirim ke server
    final formattedTanggalLahir = _formatDate(_tanggalLahirController.text);

    final url = Uri.parse('http://127.0.0.1:8000/api/pasiens/$patientId');

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nik': _nikController.text,
        'nama_pasien': _namaPasienController.text,
        'gender': _selectedGender,
        'alamat': _alamatController.text,
        'tanggal_lahir': formattedTanggalLahir,
        'no_telp': _noTelpController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update successful')),
      );

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PatientProfilePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed')),
      );
    }
  }

  // Fungsi untuk memastikan tanggal dalam format "yyyy-MM-dd"
  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length == 3) {
      final year = parts[0];
      final month = parts[1].padLeft(2, '0');
      final day = parts[2].padLeft(2, '0');
      return '$year-$month-$day';
    }
    return date;
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaPasienController.dispose();
    _alamatController.dispose();
    _tanggalLahirController.dispose();
    _noTelpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Change Data',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nikController,
                  decoration: InputDecoration(
                    labelText: 'NIK',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIK tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _namaPasienController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                  items: ['Laki-laki', 'Perempuan']
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gender tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _tanggalLahirController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    hintText: 'yyyy-mm-dd',
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      setState(() {
                        _tanggalLahirController.text = formattedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal Lahir tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _noTelpController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor Telepon tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updatePatientData();
                    }
                  },
                  child: Text('Simpan Perubahan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
