import 'package:flutter/material.dart';
import 'package:novi_indus_machine_test/constants/paths.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? userData;
  final String? token;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.userData,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? userData,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userData: userData ?? this.userData,
      token: token ?? this.token,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState();

  AuthState get state => _state;
  bool get isAuthenticated => _state.isAuthenticated;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  Map<String, dynamic>? get userData => _state.userData;
  String? get token => _state.token;

  AuthProvider() {
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userDataString = prefs.getString('userData');

      if (token != null && userDataString != null) {
        _state = _state.copyWith(
          isAuthenticated: true,
          token: token,
          userData: json.decode(userDataString),
        );
        notifyListeners();
      }
    } catch (e) {
      _state = _state.copyWith(error: 'Failed to load stored data: $e');
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final url = Uri.parse('$baseUrl$userLogin');
      final request = http.MultipartRequest('POST', url)
        ..fields['username'] = username
        ..fields['password'] = password
        ..headers.addAll({'Content-Type': 'multipart/form-data'});

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true) {
          await _saveAuthData(data['token'], data['user_details']);
          return true;
        } else {
          _handleError('Login failed: ${data['message'] ?? 'Unknown error'}');
          return false;
        }
      } else {
        _handleError('Server error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _handleError('Network error: $e');
      return false;
    } finally {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> _saveAuthData(String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userData', json.encode(userData));

    _state = _state.copyWith(
      isAuthenticated: true,
      token: token,
      userData: userData,
      error: null,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _state = AuthState();
    notifyListeners();
  }

  void _handleError(String message) {
    _state = _state.copyWith(
      error: message,
      isAuthenticated: false,
      token: null,
      userData: null,
    );
    notifyListeners();
  }
}
