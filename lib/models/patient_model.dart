// patient_model.dart
import 'dart:convert';

import 'dart:convert';

class Patient {
  bool status;
  String message;
  List<PatientElement> patients;

  Patient({
    required this.status,
    required this.message,
    required this.patients,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    status: json["status"] ?? false,
    message: json["message"] ?? '',
    patients: json["patient"] == null
        ? []
        : List<PatientElement>.from(
        (json["patient"] as List).map((x) => PatientElement.fromJson(x))),
  );
}

class PatientElement {
  int id;
  List<PatientDetailsSet> patientDetailsSet;
  Branch? branch;
  String user;
  String payment;
  String name;
  String phone;
  String address;
  double? price;
  int totalAmount;
  int discountAmount;
  int advanceAmount;
  int balanceAmount;
  DateTime? dateNdTime;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  PatientElement({
    required this.id,
    required this.patientDetailsSet,
    required this.branch,
    required this.user,
    required this.payment,
    required this.name,
    required this.phone,
    required this.address,
    this.price,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    this.dateNdTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientElement.fromJson(Map<String, dynamic> json) => PatientElement(
    id: json["id"],
    patientDetailsSet: List<PatientDetailsSet>.from(
        json["patientdetails_set"].map((x) => PatientDetailsSet.fromJson(x))),
    branch: json["branch"] != null ? Branch.fromJson(json["branch"]) : null,
    user: json["user"],
    payment: json["payment"],
    name: json["name"],
    phone: json["phone"],
    address: json["address"],
    price: (json["price"] != null) ? double.tryParse(json["price"].toString()) : null,
    totalAmount: json["total_amount"],
    discountAmount: json["discount_amount"],
    advanceAmount: json["advance_amount"],
    balanceAmount: json["balance_amount"],
    dateNdTime: json["date_nd_time"] != null
        ? DateTime.parse(json["date_nd_time"])
        : null,
    isActive: json["is_active"] ?? false,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}
class Branch {
  int id;
  String name;
  int patientsCount;
  String location;
  String phone;
  String mail;
  String address;
  String gst;
  bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.patientsCount,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    name: json["name"],
    patientsCount: json["patients_count"],
    location: json["location"],
    phone: json["phone"],
    mail: json["mail"],
    address: json["address"],
    gst: json["gst"],
    isActive: json["is_active"],
  );
}

class PatientDetailsSet {
  int id;
  String male;
  String female;
  int patient;
  int? treatment;
  String? treatmentName;

  PatientDetailsSet({
    required this.id,
    required this.male,
    required this.female,
    required this.patient,
    this.treatment,
    this.treatmentName,
  });

  factory PatientDetailsSet.fromJson(Map<String, dynamic> json) =>
      PatientDetailsSet(
        id: json["id"],
        male: json["male"],
        female: json["female"],
        patient: json["patient"],
        treatment: json["treatment"],
        treatmentName: json["treatment_name"],
      );
}
