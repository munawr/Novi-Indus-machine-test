import 'branch_model.dart'; // Import this if `Branch` is in a separate file

class TreatmentListModel {
  final int? id;
  final String? name;
  final String? duration;
  final String? price;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<BranchListModel>? branches; // Add branches field

  TreatmentListModel({
    this.id,
    this.name,
    this.duration,
    this.price,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.branches, // Initialize branches here
  });

  factory TreatmentListModel.fromJson(Map<String, dynamic> json) {
    return TreatmentListModel(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String?)?.trim() ?? '',
      duration: (json['duration'] as String?)?.trim() ?? '',
      price: json['price'] as String? ?? '0',
      isActive: json['is_active'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      branches: (json['branches'] as List<dynamic>?) // Update branches parsing
              ?.map((branch) => BranchListModel.fromJson(branch))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'branches': branches?.map((branch) => branch.toJson()).toList(),
    };
  }
}
