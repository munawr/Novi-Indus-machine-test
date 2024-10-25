import 'package:flutter/material.dart';
import 'package:novi_indus_machine_test/pages/home.dart';
import 'package:novi_indus_machine_test/pages/login.dart';
import 'package:novi_indus_machine_test/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'providers/patient_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientProvider()..fetchPatients()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => const PatientListScreen(),
      },
    );
  }
}
