class User {
  final String id;
  final String name;
  final String email;
  final String? mobile;
  final String dob;
  final List<String> images;
  final String profilePic;
  final List<String> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    required this.dob,
    required this.images,
    required this.profilePic,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'images': images,
      'profilePic': profilePic,
      'addresses': addresses,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '_id': id,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'],
      dob: json['dob'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      profilePic:
          json['profilePic'] ??
          'https://i.pinimg.com/474x/fa/d5/e7/fad5e79954583ad50ccb3f16ee64f66d.jpg',
      addresses: List<String>.from(json['addresses'] ?? []),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
