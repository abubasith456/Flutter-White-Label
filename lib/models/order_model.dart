import 'package:demo_app/models/address_model.dart';
import 'package:demo_app/models/cart_model.dart';

class OrderItem {
  final String productId;
  final String sizeLabel;
  final int quantity;
  final double priceAtPurchase;
  final String? productName;
  final List<String>? productImages;

  OrderItem({
    required this.productId,
    required this.sizeLabel,
    required this.quantity,
    required this.priceAtPurchase,
    this.productName,
    this.productImages,
  });

  // Convert OrderItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'product': productId,
      'sizeLabel': sizeLabel,
      'quantity': quantity,
      'priceAtPurchase': priceAtPurchase,
    };
  }

  // Create OrderItem from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Handle case where product might be an object or just an ID
    String productId;
    String? productName;
    List<String>? productImages;

    if (json['product'] is Map) {
      final productMap = json['product'] as Map<String, dynamic>;
      productId = productMap['_id'].toString();
      productName = productMap['name']?.toString();

      // Handle images if available
      if (productMap['images'] != null && productMap['images'] is List) {
        productImages =
            (productMap['images'] as List)
                .map((img) => img.toString())
                .toList();
      }
    } else {
      productId = json['product'].toString();
    }

    return OrderItem(
      productId: productId,
      sizeLabel: json['sizeLabel'] ?? '',
      quantity: json['quantity'],
      priceAtPurchase:
          json['priceAtPurchase'] is int
              ? json['priceAtPurchase'].toDouble()
              : double.parse(json['priceAtPurchase'].toString()),
      productName: productName,
      productImages: productImages,
    );
  }

  // Create OrderItem from CartItem
  factory OrderItem.fromCartItem(CartItem cartItem) {
    // Use the selectedSize if available, otherwise use a default value
    // or the first size from the product's sizes list if available
    String sizeLabel = cartItem.selectedSize ?? '1 Piece';
    if (sizeLabel == '1 Piece' && cartItem.product.sizes.isNotEmpty) {
      sizeLabel = cartItem.product.sizes.first.label;
    }

    return OrderItem(
      productId: cartItem.product.id,
      sizeLabel: sizeLabel,
      quantity: cartItem.quantity,
      priceAtPurchase: cartItem.product.price,
      productName: cartItem.product.name,
      productImages: cartItem.product.images,
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
    required this.fullName,
    required this.mobile,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.postalCode,
    this.country = 'India',
  });

  // Convert ShippingAddress to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'mobile': mobile,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  // Create ShippingAddress from JSON
  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'] ?? '',
      mobile: json['mobile'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? 'India',
    );
  }

  // Create ShippingAddress from AddressModel
  factory ShippingAddress.fromAddressModel(AddressModel address) {
    return ShippingAddress(
      fullName: address.name,
      mobile: address.phone,
      addressLine1:
          address.address, // Using the 'address' field instead of 'street'
      addressLine2:
          '', // No separate field for landmark/addressLine2 in AddressModel
      city: address.city,
      state: address.state,
      postalCode: address.zipCode,
      country: 'India', // Default to India
    );
  }
}

class OrderModel {
  final String? id;
  final String? userId;
  final List<OrderItem> items;
  final double totalAmount;
  final ShippingAddress shippingAddress;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;

  OrderModel({
    this.id,
    this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    this.status = 'Pending',
    this.paymentStatus = 'Pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Order to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress.toJson(),
      'status': status,
      'paymentStatus': paymentStatus,
    };
  }

  // Create Order from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle userId which can be a Map or a String
    String? userId;
    if (json['userId'] is Map) {
      userId = json['userId']['_id']?.toString();
    } else {
      userId = json['userId']?.toString();
    }

    return OrderModel(
      id: json['_id'],
      userId: userId,
      items:
          (json['items'] as List)
              .map(
                (item) => OrderItem.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(),
      totalAmount:
          json['totalAmount'] is int
              ? json['totalAmount'].toDouble()
              : double.parse(json['totalAmount'].toString()),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
    );
  }
}
