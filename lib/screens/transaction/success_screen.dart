import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:pos_coffee_shop/providers/payment_provider.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/success/custom_appbar.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatelessWidget {
  final Payment? payment;
  const SuccessScreen({super.key, this.payment});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentProvider.fetchCustomerName(payment!.orderId);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppbar(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Congratulations!!!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/icons/animated/payment.gif', height: 200),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "Order",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        payment!.orderId,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.color5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.color5,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Consumer',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Consumer<PaymentProvider>(
                                builder: (context, paymentProvider, _) {
                                  return Text(paymentProvider.customerName);
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Total : ${formatCurrency(payment!.totalAmount)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Your order has been taken and is being attended',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.color7,
                            ),
                          ),
                          icon: SvgCustomApp.getIcon(
                            'home',
                            c: AppColors.color5,
                          ),
                          onPressed: () {
                            cartProvider.items.clear();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.cashierHome,
                              (route) => false,
                            );
                          },
                          label: Text(
                            "Home",
                            style: TextStyle(
                              color: AppColors.color5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.primary,
                            ),
                          ),
                          icon: SvgCustomApp.getIcon(
                            "print",
                            c: AppColors.color5,
                          ),
                          onPressed: () {},
                          label: Text(
                            "Invoice",
                            style: TextStyle(
                              color: AppColors.color5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavBar(onPayPressed: onPayPressed),
    );
  }
}
