class BranchListModel {
  int? id;
  String? name;
  int? patientsCount;
  String? location; // Update location to String to match your JSON
  String? phone;
  String? mail;
  String? address;
  String? gst;
  bool? isActive;

  BranchListModel({
     this.id,
     this.name,
     this.patientsCount,
     this.location,
     this.phone,
     this.mail,
     this.address,
     this.gst,
     this.isActive,
  });

  factory BranchListModel.fromJson(Map<String, dynamic> json) {
    return BranchListModel(
      id: json['id'],
      name: json['name'],
      // Use 'patients_count' from the JSON response, handle nulls
      patientsCount:
          json['patients_count'] != null ? json['patients_count'] : 0,
      location: json['location'] ?? 'Unknown Location', // Handle possible nulls
      phone: json['phone'] ?? 'No phone number', // Default if null
      mail: json['mail'] ?? 'No email provided', // Default if null
      address: json['address'] ?? 'No address provided', // Default if null
      gst: json['gst'] ?? 'No GST provided', // Default if null
      isActive: json['is_active'] ?? false, // Default if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'patients_count': patientsCount,
      'location': location,
      'phone': phone,
      'mail': mail,
      'address': address,
      'gst': gst,
      'is_active': isActive,
    };
  }
}

// Update enum with an UNKNOWN option as a fallback
enum Locations {
  KOCHI,
  KOZHIKODE,
  KUMARAKOM_KOTTAYAM,
  UNKNOWN // New fallback option
}
