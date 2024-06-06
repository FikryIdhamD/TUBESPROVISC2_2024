import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddPatientPage extends StatefulWidget {
  final int userId;

  AddPatientPage({required this.userId});

  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaPasienController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  String? _selectedGender;

  Future<void> _addPatient() async {
    // Format tanggal sebelum mengirim ke server
    final formattedTanggalLahir = _formatDate(_tanggalLahirController.text);

    final url =
        Uri.parse('http://127.0.0.1:8000/api/${widget.userId}/pasiens/');

    final response = await http.post(
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

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient added successfully')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add patient')),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Add New Patient',
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
                      _addPatient();
                    }
                  },
                  child: Text('Tambah Pasien'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
