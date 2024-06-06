import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// Article class definition
class Artikel {
  final int idArtikel;
  final String titleArtikel;
  final String deskripsiArtikel;
  final String fotoArtikel;

  Artikel({
    required this.idArtikel,
    required this.titleArtikel,
    required this.deskripsiArtikel,
    required this.fotoArtikel,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      idArtikel: json['id_artikel'],
      titleArtikel: json['title_artikel'],
      deskripsiArtikel: json['deskripsi_artikel'],
      fotoArtikel: json['foto_artikel'],
    );
  }
}

class ArtikelProvider with ChangeNotifier {
  List<Artikel> _artikels = [];

  List<Artikel> get artikels => _artikels;

  Future<void> fetchData() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/artikels/'));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    _artikels = responseData.map((data) => Artikel.fromJson(data)).toList();
    notifyListeners();
    
    // Debugging: Print the API response
    print('API Response: ${response.body}'); 
  } else {
    throw Exception('Failed to load articles');
  }
}
}

class Patient {
  final int idPasien;
  final String nik;
  final String namaPasien;
  final String gender;
  final String alamat;
  final String tanggalLahir;
  final String noTelp;

  Patient({
    required this.idPasien,
    required this.nik,
    required this.namaPasien,
    required this.gender,
    required this.alamat,
    required this.tanggalLahir,
    required this.noTelp,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      idPasien: json['id_pasien'],
      nik: json['nik'],
      namaPasien: json['nama_pasien'],
      gender: json['gender'],
      alamat: json['alamat'],
      tanggalLahir: json['tanggal_lahir'],
      noTelp: json['no_telp'],
    );
  }
}


// hospital_model.dart
class Hospital {
  final int id;
  final String name;
  final String address;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id_hospital'],
      name: json['nama_hospital'],
      address: json['alamat'],
    );
  }
}

// speciality_model.dart
class Speciality {
  final int id;
  final String name;

  Speciality({
    required this.id,
    required this.name,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id_speciality'],
      name: json['nama_speciality'],
    );
  }
}

class ApiService {
  static const String apiUrl = 'http://127.0.0.1:8000/api'; 

  static Future<List<Patient>> fetchPatients(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/$userId/pasiens'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((patient) => Patient.fromJson(patient)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }
  Future<List<Hospital>> fetchHospitals() async {
    final response = await http.get(Uri.parse('$apiUrl/hospitals/'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print('API Response: ${response.body}'); 
      return jsonData.map((json) => Hospital.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  Future<List<Speciality>> fetchSpecialities() async {
    final response = await http.get(Uri.parse('$apiUrl/specialitys/'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print('API Response: ${response.body}'); 
      return jsonData.map((json) => Speciality.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load specialities');
    }
  }
}



class HospitalProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Hospital> hospitals = [];

  Future<void> fetchHospitals() async {
    try {
      hospitals = await apiService.fetchHospitals();
      notifyListeners();
    } catch (e) {
      print('Error fetching hospitals: $e');
    }
  }
}

class SpecialityProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Speciality> specialities = [];

  Future<void> fetchSpecialities() async {
    try {
      specialities = await apiService.fetchSpecialities();
      notifyListeners();
    } catch (e) {
      print('Error fetching specialities: $e');
    }
  }
}





// Your existing Auth class
class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = 'none';
  int _userId = -1; // Default value indicating no user ID

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  int get userId => _userId;

  void login(String username, int userId) {
    _isLoggedIn = true;
    _username = username;
    _userId = userId;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _username = 'none';
    _userId = -1;
    notifyListeners();
  }
}