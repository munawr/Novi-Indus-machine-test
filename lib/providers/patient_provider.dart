import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/patient_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientProvider extends ChangeNotifier {
  List<PatientElement> _patients = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<PatientElement> get patients => _patients;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPatients() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        _errorMessage = 'No token found. Please log in.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      var headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(
        Uri.parse('https://flutter-amr.noviindus.in/api/PatientList'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey("patient")) {
          Patient patientData = Patient.fromJson(data);
          _patients = patientData.patients;
        } else {
          _errorMessage = "Unexpected response structure";
        }
      } else if (response.statusCode == 401) {
        _errorMessage = 'User not logged in. Please log in to access this data.';
      } else {
        _errorMessage = 'Failed to fetch patients. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
