import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';

class PaymentDetail extends StatefulWidget {
  @override
  final double totalAmount;
  final double change;
  final Function(double) onAmountChanged;
  final Function(String) onPaymentMethodChanged;
  final String selectedMethod;

  const PaymentDetail({
    super.key,
    required this.totalAmount,
    required this.onAmountChanged,
    required this.change,
    required this.onPaymentMethodChanged,
    required this.selectedMethod,
  });

  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    final amount = double.tryParse(cleanValue) ?? 0.0;

    widget.onAmountChanged(amount);

    final formatted = formatCurrency(amount);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 5, color: AppColors.color3),
          if (widget.selectedMethod == 'Cash')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.color5,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: SvgCustomApp.getIcon('hand-bill'),
                    ),
                    hintText: 'Amount Received',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _onAmountChanged,
                ),
                const SizedBox(height: 8),
                Text(
                  'Change: ${widget.change > 0 ? formatCurrency(widget.change) : "Rp. 0"}',
                  style: TextStyle(fontSize: 18, color: AppColors.color7),
                ),
              ],
            ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PaymentMethodButton(
                label: 'Cash',
                isSelected: widget.selectedMethod == 'Cash',
                onTap: () => widget.onPaymentMethodChanged('Cash'),
              ),
              SizedBox(width: 20),
              PaymentMethodButton(
                label: 'QRIS',
                isSelected: widget.selectedMethod == 'QRIS',
                onTap: () => widget.onPaymentMethodChanged('QRIS'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentMethodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.color4,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.color5 : AppColors.color3,
          ),
        ),
      ),
    );
  }
}
