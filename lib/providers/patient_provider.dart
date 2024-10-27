import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/paths.dart';
import '../models/patient_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientState {
  final List<PatientElement> patients;
  final bool isLoading;
  final String? error;
  final bool isRefreshing;

  PatientState({
    this.patients = const [],
    this.isLoading = false,
    this.error,
    this.isRefreshing = false,
  });

  PatientState copyWith({
    List<PatientElement>? patients,
    bool? isLoading,
    String? error,
    bool? isRefreshing,
  }) {
    return PatientState(
      patients: patients ?? this.patients,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class PatientProvider extends ChangeNotifier {
  PatientState _state = PatientState();

  PatientState get state => _state;
  List<PatientElement> get patients => _state.patients;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;

  Future<void> fetchPatients({bool refresh = false}) async {
    if (!refresh && _state.isLoading) return;

    try {
      _state = _state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        error: null,
      );
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl$list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _processPatientData(data);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required');
      } else {
        throw Exception('Failed to fetch patients: ${response.statusCode}');
      }
    } catch (e) {
      _handleError(e.toString());
    } finally {
      _state = _state.copyWith(
        isLoading: false,
        isRefreshing: false,
      );
      notifyListeners();
    }
  }

  Future<void> _processPatientData(Map<String, dynamic> data) async {
    if (data.containsKey("patient")) {
      final patientData = Patient.fromJson(data);
      await _cacheMasterData(data);

      _state = _state.copyWith(
        patients: patientData.patients,
        error: null,
      );
    } else {
      throw Exception('Invalid data format');
    }
  }

  Future<void> _cacheMasterData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final branches = data['branches'] ?? [];
    final treatments = data['treatments'] ?? [];

    await prefs.setString('branches', json.encode(branches));
    await prefs.setString('treatments', json.encode(treatments));
  }

  void _handleError(String message) {
    _state = _state.copyWith(
      error: message,
      isLoading: false,
      isRefreshing: false,
    );
    notifyListeners();
  }
}
