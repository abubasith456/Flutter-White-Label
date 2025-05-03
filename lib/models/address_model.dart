class AddressModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String phone;
  final bool isPrimary;

  AddressModel({
    required this.id,
    required this.name,
    required this.address,
    this.city = '',
    this.state = '',
    this.zipCode = '',
    required this.phone,
    required this.isPrimary,
  });

  /// Get full address as a formatted string
  String get fullAddress {
    final List<String> parts = [address];
    
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) {
      if (zipCode.isNotEmpty) {
        parts.add('$state, $zipCode');
      } else {
        parts.add(state);
      }
    } else if (zipCode.isNotEmpty) {
      parts.add(zipCode);
    }
    
    return parts.join(', ');
  }

  AddressModel copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? phone,
    bool? isPrimary,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      phone: json['phone'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phone': phone,
      'isPrimary': isPrimary,
    };
  }
}
