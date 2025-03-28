class User {
  final String id;
  final String name;
  final String email;
  final String? mobile; // Making mobile nullable (optional)
  final String dob;
  final String image;
  final List<String> addresses;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile, // Make mobile optional
    required this.dob,
    required this.image,
    required this.addresses,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'image': image,
      'addresses': addresses,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '', // Default to empty string if null
      name: json['name'] ?? '', // Default to empty string if null
      email: json['email'] ?? '', // Default to empty string if null
      mobile: json['mobile'], // Optional mobile field (can be null)
      dob: json['dob'] ?? '', // Default to empty string if null
      image:
          json['image'] ??
          "https://i.pinimg.com/474x/fa/d5/e7/fad5e79954583ad50ccb3f16ee64f66d.jpg", // Default to a predefined image if null or empty
      addresses: List<String>.from(
        json['addresses'] is List && json['addresses'].isNotEmpty
            ? json['addresses']
            : [
              'No Address Provided',
            ], // Default to a sample address if null or empty
      ),
    );
  }
}
