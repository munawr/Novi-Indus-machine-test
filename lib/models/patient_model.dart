// patient_model.dart

class Patient {
  final bool status;
  final String message;
  final List<PatientElement> patients;

  Patient({
    required this.status,
    required this.message,
    required this.patients,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      status: json["status"] ?? false,
      message: json["message"] ?? '',
      patients: json["patient"] == null
          ? []
          : List<PatientElement>.from(
          (json["patient"] as List).map((x) => PatientElement.fromJson(x))),
    );
  }
}

class PatientElement {
  final int id;
  final List<PatientDetailsSet?> patientDetailsSet;
  final Branch? branch;
  final String user;
  final String payment;
  final String name;
  final String phone;
  final String address;
  final double? price;
  final int totalAmount;
  final int discountAmount;
  final int advanceAmount;
  final int balanceAmount;
  final DateTime? dateNdTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

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

  factory PatientElement.fromJson(Map<String, dynamic> json) {
    return PatientElement(
      id: json["id"] ?? 0,
      patientDetailsSet: (json["patientdetails_set"] as List<dynamic>?)
          ?.map((x) => PatientDetailsSet.fromJson(x))
          .toList() ??
          [],
      branch: json["branch"] != null ? Branch.fromJson(json["branch"]) : null,
      user: json["user"] ?? '',
      payment: json["payment"] ?? '',
      name: json["name"] ?? '',
      phone: json["phone"] ?? '',
      address: json["address"] ?? '',
      price: json["price"] != null ? double.tryParse(json["price"].toString()) : null,
      totalAmount: json["total_amount"] ?? 0,
      discountAmount: json["discount_amount"] ?? 0,
      advanceAmount: json["advance_amount"] ?? 0,
      balanceAmount: json["balance_amount"] ?? 0,
      dateNdTime: json["date_nd_time"] != null
          ? DateTime.tryParse(json["date_nd_time"])
          : null,
      isActive: json["is_active"] ?? false,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}

class Branch {
  final int id;
  final String name;
  final int patientsCount;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;

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

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      patientsCount: json["patients_count"] ?? 0,
      location: json["location"] ?? '',
      phone: json["phone"] ?? '',
      mail: json["mail"] ?? '',
      address: json["address"] ?? '',
      gst: json["gst"] ?? '',
      isActive: json["is_active"] ?? false,
    );
  }
}

class PatientDetailsSet {
  final int id;
  final String male;
  final String female;
  final int patient;
  final int? treatment;
  final String? treatmentName;

  PatientDetailsSet({
    required this.id,
    required this.male,
    required this.female,
    required this.patient,
    this.treatment,
    this.treatmentName,
  });

  factory PatientDetailsSet.fromJson(Map<String, dynamic> json) {
    return PatientDetailsSet(
      id: json["id"] ?? 0,
      male: json["male"] ?? '',
      female: json["female"] ?? '',
      patient: json["patient"] ?? 0,
      treatment: json["treatment"],
      treatmentName: json["treatment_name"],
    );
  }
}
