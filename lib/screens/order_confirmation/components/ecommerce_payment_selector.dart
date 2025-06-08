import 'package:demo_app/app_config.dart';
import 'package:flutter/material.dart';

class EcommercePaymentSelector extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final String selectedMethod;
  final Function(String) onMethodChanged;

  const EcommercePaymentSelector({
    Key? key,
    required this.paymentMethods,
    required this.selectedMethod,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          paymentMethods.map((method) {
            final isSelected = method['name'] == selectedMethod;
            final isPopular = method['popular'] ?? false;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onMethodChanged(method['name']),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppConfig.primaryColor.withOpacity(0.08)
                            : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppConfig.primaryColor
                              : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: AppConfig.primaryColor.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : null,
                  ),
                  child: Row(
                    children: [
                      // Payment method icon
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppConfig.primaryColor.withOpacity(0.1)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppConfig.primaryColor.withOpacity(0.3)
                                    : Colors.grey[300]!,
                          ),
                        ),
                        child: Icon(
                          _getPaymentIcon(method['name']),
                          color:
                              isSelected
                                  ? AppConfig.primaryColor
                                  : Colors.grey[600],
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Payment method name and popular tag
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Wrap the row with popular tag in a flexible container
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    method['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isSelected
                                              ? AppConfig.primaryColor
                                              : const Color(0xFF1A1A1A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                if (isPopular) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'POPULAR',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getPaymentDescription(method['name']),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Selection indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected
                                  ? AppConfig.primaryColor
                                  : Colors.transparent,
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppConfig.primaryColor
                                    : Colors.grey[400]!,
                            width: 2,
                          ),
                        ),
                        child:
                            isSelected
                                ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                )
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'Credit Card':
        return Icons.credit_card_rounded;
      case 'Debit Card':
        return Icons.credit_card_outlined;
      case 'Cash on Delivery':
        return Icons.money_rounded;
      case 'UPI':
        return Icons.qr_code_2_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  String _getPaymentDescription(String method) {
    switch (method) {
      case 'Credit Card':
        return 'Secure payment with credit card';
      case 'Debit Card':
        return 'Pay using your debit card';
      case 'Cash on Delivery':
        return 'Pay when order arrives';
      case 'UPI':
        return 'Quick payment via UPI apps';
      default:
        return 'Secure payment method';
    }
  }
}
