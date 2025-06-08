import 'package:demo_app/app_config.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/models/order_model.dart';
import 'package:flutter/material.dart';

class ShippingAddressCard extends StatelessWidget {
  final ShippingAddress address;

  const ShippingAddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConfig.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConfig.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: AppConfig.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Shipping Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConfig.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppConfig.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        address.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: AppConfig.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        address.mobile,
                        style: const TextStyle(
                          color: blackColor60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: AppConfig.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.addressLine1,
                              style: const TextStyle(
                                color: blackColor,
                                fontSize: 14,
                              ),
                            ),
                            if (address.addressLine2.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                address.addressLine2,
                                style: const TextStyle(
                                  color: blackColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              "${address.city}, ${address.state} ${address.postalCode}",
                              style: const TextStyle(
                                color: blackColor60,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              address.country,
                              style: const TextStyle(
                                color: blackColor60,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
