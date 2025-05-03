import 'package:demo_app/models/api_model/product_model.dart';
import 'package:demo_app/models/api_model/user_model.dart';

class OrderModel {
  final String id;
  final User user;
  final List<OrderItem> items;
  final double totalAmount;
  final ShippingAddress shippingAddress;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;

  OrderModel({
    this.id = '',
    required this.user,
    this.items = const [],
    this.totalAmount = 0.0,
    required this.shippingAddress,
    this.status = 'Pending',
    this.paymentStatus = 'Pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      user: User.fromJson(json['userId'] ?? {}),
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((item) => OrderItem.fromJson(item))
              .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress'] ?? {}),
      status: json['status'] ?? 'Pending',
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class OrderItem {
  final String id;
  final Product product;
  final String sizeLabel;
  final int quantity;
  final double priceAtPurchase;

  OrderItem({
    this.id = '',
    required this.product,
    this.sizeLabel = '',
    this.quantity = 0,
    this.priceAtPurchase = 0.0,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      sizeLabel: json['sizeLabel'] ?? '',
      quantity: json['quantity'] ?? 0,
      priceAtPurchase: (json['priceAtPurchase'] ?? 0).toDouble(),
    );
  }
}

class ShippingAddress {
  final String fullName;
  final String mobile;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  ShippingAddress({
    this.fullName = '',
    this.mobile = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'] ?? '',
      mobile: json['mobile'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
