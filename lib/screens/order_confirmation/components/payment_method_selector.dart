import 'package:demo_app/app_config.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<String> paymentMethods;
  final String selectedMethod;
  final Function(String) onMethodChanged;

  const PaymentMethodSelector({
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
            final isSelected = method == selectedMethod;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onMethodChanged(method),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppConfig.primaryColor.withOpacity(0.1)
                            : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppConfig.primaryColor
                              : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getPaymentIcon(method),
                        color:
                            isSelected
                                ? AppConfig.primaryColor
                                : Colors.grey[600],
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          method,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color:
                                isSelected
                                    ? AppConfig.primaryColor
                                    : Colors.grey[800],
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: AppConfig.primaryColor,
                          size: 24,
                        )
                      else
                        Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.grey[400],
                          size: 24,
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
        return Icons.credit_card;
      case 'Debit Card':
        return Icons.credit_card_outlined;
      case 'Cash on Delivery':
        return Icons.money;
      case 'UPI':
        return Icons.qr_code;
      default:
        return Icons.payment;
    }
  }
}
