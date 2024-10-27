class RegisterPatientModel {
  final String name;
  final String executive;
  final String payment;
  final String phone;
  final String address;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final String dateAndTime;
  final String? id;
  final List<int> male;
  final List<int> female;
  final dynamic branch;
  final List<int> treatments;

  RegisterPatientModel({
    required this.name,
    required this.executive,
    required this.payment,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateAndTime,
    required this.id,
    required this.male,
    required this.female,
    required this.branch,
    required this.treatments,
  });

  // Convert RegisterPatientModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'executive': executive,
      'payment': payment,
      'phone': phone,
      'address': address,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'advanceAmount': advanceAmount,
      'balanceAmount': balanceAmount,
      'dateAndTime': dateAndTime,
      'id': id,
      'male': male,
      'female': female,
      'branch': branch,
      'treatments': treatments,
    };
  }
}
