import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _userData;

  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('https://flutter-amr.noviindus.in/api/Login');
    var request = http.MultipartRequest('POST', url);

    request.fields['username'] = username;
    request.fields['password'] = password;
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        final data = jsonDecode(res);

        if (data['status'] == true) {
          _token = data['token'];
          _userData = data['user_details'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', _token!);
          await prefs.setString('userData', jsonEncode(_userData));

          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        print("Login failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<void> loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      _userData = jsonDecode(userDataString);
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _userData = null;
    notifyListeners();
  }
}
