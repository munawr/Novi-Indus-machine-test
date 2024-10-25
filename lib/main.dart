import 'package:flutter/material.dart';
import 'package:novi_indus_machine_test/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadStoredData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _token;

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    var headers = {
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://flutter-amr.noviindus.in/api/Login'),
    );

    request.fields['username'] = _usernameController.text;
    request.fields['password'] = _passwordController.text;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print(response);

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (jsonResponse['status'] == true) {
        setState(() {
          _token = jsonResponse['token'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  login();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
