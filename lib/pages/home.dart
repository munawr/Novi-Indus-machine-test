import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/patient_model.dart';
import '../providers/patient_provider.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        Provider.of<PatientProvider>(context, listen: false).fetchPatients();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Patient List")),
      body: RefreshIndicator(
        onRefresh: () async {
          await patientProvider.fetchPatients();
        },
        child: patientProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : patientProvider.errorMessage.isNotEmpty
            ? Center(child: Text(patientProvider.errorMessage))
            : patientProvider.patients.isEmpty
            ? Center(child: Image.asset("assets/images/empty_list.png"))
            : ListView.builder(
          itemCount: patientProvider.patients.length,
          itemBuilder: (context, index) {
            final patient = patientProvider.patients[index];
            return PatientCard(patient: patient);
          },
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final PatientElement patient;

  const PatientCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${patient.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Phone: ${patient.phone}'),
            Text('Address: ${patient.address}'),
            Text('Branch: ${patient.branch?.name ?? 'Unknown'}'),
            Text('Payment Method: ${patient.payment}'),
            Text('Total Amount: ${patient.totalAmount}'),
          ],
        ),
      ),
    );
  }
}
