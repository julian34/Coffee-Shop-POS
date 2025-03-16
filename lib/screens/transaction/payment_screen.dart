import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/providers/payment_provider.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/bottom_nav_bar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/consumer_details.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/custom_appbar.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/list_products.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/payment/payment_detail.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final OrderList? orderList;
  const PaymentScreen({super.key, this.orderList});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double receivedAmount = 0.0;
  String paymentMethod = 'Cash';
  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.orderList!.totalAmount ?? 0.0;
    double change = receivedAmount - totalAmount;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppbar(cartId: widget.orderList!.cartId),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConsumerDetailsTab(
            customerName: widget.orderList!.customerName,
            totalAmount: widget.orderList!.totalAmount,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ordered",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                Divider(color: AppColors.color3),
              ],
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: ListProducts(orderItems: widget.orderList!.items),
            ),
          ),
          PaymentDetail(
            totalAmount: widget.orderList!.totalAmount.toDouble(),
            onAmountChanged: (value) {
              setState(() => receivedAmount = value);
            },
            change: change,
            onPaymentMethodChanged: (method) {
              setState(() => paymentMethod = method);
            },
            selectedMethod: paymentMethod,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(onPayPressed: _processPayment),
    );
  }

  Future<void> _processPayment() async {
    try {
      final paymentProvider = Provider.of<PaymentProvider>(
        context,
        listen: false,
      );
      final payment = Payment(
        orderId: widget.orderList!.cartId,
        totalAmount: widget.orderList!.totalAmount,
        receivedAmount: receivedAmount,
        changeAmount: receivedAmount - (widget.orderList!.totalAmount ?? 0.0),
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
      );
      print(payment.toMap());
      paymentProvider.makePayment(payment);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.successpayment,
        ModalRoute.withName(AppRoutes.cashierHome),
        arguments: payment,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment Successful!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
