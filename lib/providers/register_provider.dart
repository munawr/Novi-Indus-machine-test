import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../constants/paths.dart';
import '../models/branch_model.dart';
import '../models/treatment_model.dart';
import '../pages/register_screen/widgets/pdf_generation.dart';

enum Gender { Male, Female }
enum Location { TRIVANDRUM, KOLLAM, KOTTAYAM }
enum PaymentMethod { CASH, CARD, UPI }

class RegisterState {
  final List<BranchListModel> branches;
  final List<TreatmentListModel> treatments;
  final bool isLoading;
  final String? error;
  final String name;
  final String executive;
  final String phone;
  final String address;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final String dateAndTime;
  final String selectedBranch;
  final Location selectedLocation;
  final PaymentMethod selectedPaymentMethod;
  final Gender? selectedGender;
  final List<String> selectedMaleTreatments;
  final List<String> selectedFemaleTreatments;
  final List<String> selectedTreatments;

  RegisterState({
    this.branches = const [],
    this.treatments = const [],
    this.isLoading = false,
    this.error,
    this.name = '',
    this.executive = '',
    this.phone = '',
    this.address = '',
    this.totalAmount = 0.0,
    this.discountAmount = 0.0,
    this.advanceAmount = 0.0,
    this.balanceAmount = 0.0,
    this.dateAndTime = '',
    this.selectedBranch = '',
    this.selectedLocation = Location.TRIVANDRUM,
    this.selectedPaymentMethod = PaymentMethod.CASH,
    this.selectedGender,
    this.selectedMaleTreatments = const [],
    this.selectedFemaleTreatments = const [],
    this.selectedTreatments = const [],
  });

  RegisterState copyWith({
    List<BranchListModel>? branches,
    List<TreatmentListModel>? treatments,
    bool? isLoading,
    String? error,
    String? name,
    String? executive,
    String? phone,
    String? address,
    double? totalAmount,
    double? discountAmount,
    double? advanceAmount,
    double? balanceAmount,
    String? dateAndTime,
    String? selectedBranch,
    Location? selectedLocation,
    PaymentMethod? selectedPaymentMethod,
    Gender? selectedGender,
    List<String>? selectedMaleTreatments,
    List<String>? selectedFemaleTreatments,
    List<String>? selectedTreatments,
  }) {
    return RegisterState(
      branches: branches ?? this.branches,
      treatments: treatments ?? this.treatments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      name: name ?? this.name,
      executive: executive ?? this.executive,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      dateAndTime: dateAndTime ?? this.dateAndTime,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedMaleTreatments: selectedMaleTreatments ?? this.selectedMaleTreatments,
      selectedFemaleTreatments: selectedFemaleTreatments ?? this.selectedFemaleTreatments,
      selectedTreatments: selectedTreatments ?? this.selectedTreatments,
    );
  }
}
class RegisterProvider extends ChangeNotifier {
  RegisterState _state = RegisterState();
  late final SharedPreferences _prefs;
  final http.Client _client = http.Client();
  // static const String baseUrl = 'https://flutter-amr.noviindus.in/api';

  RegisterProvider() {
    _initializeProvider();
  }

  RegisterState get state => _state;

  Future<void> _initializeProvider() async {
    _prefs = await SharedPreferences.getInstance();
    loadData();
  }

  Future<void> loadData() async {
    try {
      _state = _state.copyWith(isLoading: true);
      notifyListeners();

      final branchesResponse = await _makeAuthenticatedRequest('$baseUrl/BranchList');
      final treatmentsResponse = await _makeAuthenticatedRequest('$baseUrl/TreatmentList');

      final branches = (branchesResponse['branches'] as List)
          .map((data) => BranchListModel.fromJson(data))
          .toList();
      final treatments = (treatmentsResponse['treatments'] as List)
          .map((data) => TreatmentListModel.fromJson(data))
          .toList();

      _state = _state.copyWith(
        branches: branches,
        treatments: treatments,
        error: null,
      );
    } catch (e) {
      _state = _state.copyWith(error: 'Failed to load data: $e');
    } finally {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> registerPatient() async {
    try {
      _state = _state.copyWith(isLoading: true);
      notifyListeners();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/PatientUpdate'),
      );

      final token = _prefs.getString('token');
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields.addAll({
        'name': _state.name,
        'excecutive': _state.executive,
        'payment': _state.selectedPaymentMethod.toString().split('.').last.toLowerCase(),
        'phone': _state.phone,
        'address': _state.address,
        'total_amount': _state.totalAmount.toString(),
        'discount_amount': _state.discountAmount.toString(),
        'advance_amount': _state.advanceAmount.toString(),
        'balance_amount': _state.balanceAmount.toString(),
        'date_nd_time': _state.dateAndTime,
        'id': '0', // Changed from empty string to '0' for new patients
        'male': _state.selectedMaleTreatments.join(','),
        'female': _state.selectedFemaleTreatments.join(','),
        'branch': _state.selectedBranch,
        'treatments': _state.selectedTreatments.join(','),
      });

      final response = await request.send();
      
      if (response.statusCode == 200) {
        
        _state = _state.copyWith(error: null);
        _resetForm();
      } else {
        throw Exception('Registration failed with status ${response.statusCode}');
      }
    } catch (e) {
      _state = _state.copyWith(error: 'Registration failed: $e');
    } finally {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _makeAuthenticatedRequest(String url) async {
    final token = _prefs.getString('token');
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
      
    } else {
      throw Exception('API request failed: ${response.statusCode}');
    }
  }

  void updateField(String field, dynamic value) {
    switch (field) {
      case 'name':
        _state = _state.copyWith(name: value as String);
        break;
      case 'executive':
        _state = _state.copyWith(executive: value as String);
        break;
      case 'phone':
        _state = _state.copyWith(phone: value as String);
        break;
      case 'address':
        _state = _state.copyWith(address: value as String);
        break;
      case 'totalAmount':
        _state = _state.copyWith(totalAmount: value as double);
        break;
      case 'discountAmount':
        _state = _state.copyWith(discountAmount: value as double);
        break;
      case 'advanceAmount':
        _state = _state.copyWith(advanceAmount: value as double);
        break;
      case 'dateAndTime':
        _state = _state.copyWith(dateAndTime: value as String);
        break;
      case 'selectedBranch':
        _state = _state.copyWith(selectedBranch: value as String);
        break;
      case 'selectedLocation':
        _state = _state.copyWith(selectedLocation: value as Location);
        break;
      case 'selectedPaymentMethod':
        _state = _state.copyWith(selectedPaymentMethod: value as PaymentMethod);
        break;
      case 'selectedGender':
        _state = _state.copyWith(selectedGender: value as Gender);
        break;
    }
    notifyListeners();
  }

  void updateTreatments(List<String> maleTreatments, List<String> femaleTreatments) {
    _state = _state.copyWith(
      selectedMaleTreatments: maleTreatments,
      selectedFemaleTreatments: femaleTreatments,
      selectedTreatments: [...maleTreatments, ...femaleTreatments],
    );
    calculateTotalAmount();
    notifyListeners();
  }

  void calculateTotalAmount() {
    double total = 0.0;
    
    // Calculate total for male treatments
    for (String treatmentId in _state.selectedMaleTreatments) {
      final treatment = _state.treatments.firstWhere(
        (t) => t.id.toString() == treatmentId,
        orElse: () => TreatmentListModel(),
      );
      total += double.tryParse(treatment.price ?? '0') ?? 0.0;
    }

    // Calculate total for female treatments
    for (String treatmentId in _state.selectedFemaleTreatments) {
      final treatment = _state.treatments.firstWhere(
        (t) => t.id.toString() == treatmentId,
        orElse: () => TreatmentListModel(),
      );
      total += double.tryParse(treatment.price ?? '0') ?? 0.0;
    }

    _state = _state.copyWith(totalAmount: total);
    calculateBalanceAmount();
  }

  void calculateBalanceAmount() {
    final balanceAmount = _state.totalAmount - _state.discountAmount - _state.advanceAmount;
    _state = _state.copyWith(balanceAmount: balanceAmount);
    notifyListeners();
  }

  void _resetForm() {
    _state = RegisterState(
      branches: _state.branches,
      treatments: _state.treatments,
    );
    notifyListeners();
  }
  Future<void> generateAndDownloadPDF() async {
  try {
    final file = await PatientPDFGenerator.generatePDF(_state);
    // You might want to show a success message using your preferred method
    print('PDF generated successfully at: ${file.path}');
  } catch (e) {
    print('Error generating PDF: $e');
    // Handle error appropriately
  }
}
}