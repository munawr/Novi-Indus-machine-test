import 'package:flutter/material.dart';
import 'package:novi_indus_machine_test/pages/home.dart';
import 'package:novi_indus_machine_test/pages/register_screen/register.dart';
import 'package:novi_indus_machine_test/providers/auth_provider.dart';
import 'package:novi_indus_machine_test/providers/register_provider.dart';
import 'package:provider/provider.dart';
import 'pages/login.dart';
import 'providers/patient_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PatientProvider()..fetchPatients()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patient Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => const PatientListScreen(),
        '/register_patient': (context) => RegisterScreen(),
      },
    );
  }
}
