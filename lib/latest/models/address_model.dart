class AddressModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final bool isPrimary;

  AddressModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.isPrimary,
  });

  /// ✅ Add this copyWith method to fix the error
  AddressModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    bool? isPrimary,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      isPrimary: json['isPrimary'] ?? false, // Default to false if missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'isPrimary': isPrimary,
    };
  }
}
