import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:pos_coffee_shop/providers/payment_provider.dart';
import 'package:pos_coffee_shop/screens/transaction/widgets/success/custom_appbar.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessScreen extends StatefulWidget {
  final Payment? payment;
  const SuccessScreen({super.key, this.payment});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  List<BluetoothInfo> _devices = [];
  String optionprinttype = "58 mm";
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _showPrinterPopup);
  }

  Future<void> _showPrinterPopup() async {
    List<BluetoothInfo> devices = await _scanBluetoothDevice();
    if (devices.isEmpty) {
      _showSnackBar("No Bluetooth printers found.");
      return;
    }
    BluetoothInfo? selectedDevice = await showDialog<BluetoothInfo>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Select a Bluetooh Printer"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return ListTile(
                    title: Text(device.name ?? "Unknown"),
                    subtitle: Text(device.macAdress),
                    onTap: () {
                      Navigator.pop(context, device);
                    },
                  );
                },
              ),
            ),
          ),
    );

    if (selectedDevice != null) {
      _connectAndPrint(selectedDevice);
    }
  }

  Future<void> _saveSelectedDevice(BluetoothInfo device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_name', device.name ?? "Unknown");
    await prefs.setString('printer_mac', device.macAdress);
    print("Saved Printer: ${device.name}");
  }

  //Scan for paired Bluetooth device
  Future<List<BluetoothInfo>> _scanBluetoothDevice() async {
    bool isAvailable = await PrintBluetoothThermal.bluetoothEnabled;
    if (isAvailable) {
      return await PrintBluetoothThermal.pairedBluetooths;
    }
    _showSnackBar("Please enable Bluetooth.");
    return [];
  }

  Future<void> _connectAndPrint(BluetoothInfo device) async {
    setState(() => _isPrinting = true);
    print(device.name);
    await PrintBluetoothThermal.connect(macPrinterAddress: device.macAdress);
    bool isConnected = await PrintBluetoothThermal.connectionStatus;

    if (isConnected) {
      print("Connected to ${device.name}");
      List<int> ticket = await _generateReceipt();
      await PrintBluetoothThermal.writeBytes(ticket);
      _showSnackBar("Receipt printed successfully.");
    } else {
      print("Failed to connect");
    }
    setState(() => _isPrinting = false);
  }

  Future<List<int>> _generateReceipt() async {
    final provider = Provider.of<PaymentProvider>(context, listen: false);
    final itemsOrder = await provider.fetchItemOrder(widget.payment!.orderId);
    final items = itemsOrder ?? [];

    print(itemsOrder);
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(
      optionprinttype == '58 mm' ? PaperSize.mm58 : PaperSize.mm80,
      profile,
    );
    bytes += generator.reset();
    bytes += generator.text(
      '=== Raftel Cafe Jayapura ===',
      styles: PosStyles(bold: true, align: PosAlign.center),
    );

    bytes += generator.text(
      'Order : ${widget.payment!.orderId}',
      styles: PosStyles(bold: true, align: PosAlign.left),
    );

    bytes += generator.text(
      'Customer',
      styles: PosStyles(bold: true, align: PosAlign.left),
    );

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Items',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'Price',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'Total',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    for (var item in items) {
      String itemName = item['name'] ?? 'Unknown';
      int quantity = item['quantity'] ?? 1;
      double price = (item['price'] ?? 0).toDouble();
      double subtotal = (item['price'] ?? 0).toDouble();

      bytes += generator.row([
        PosColumn(
          text: '$itemName x $quantity',
          width: 6,
          styles: const PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: '${formatCurrency(price)}',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, underline: true),
        ),
        PosColumn(
          text: '${formatCurrency(subtotal)}',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, underline: true),
        ),
      ]);
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 4,
        styles: const PosStyles(align: PosAlign.left, underline: true),
      ),
      PosColumn(
        text: '${formatCurrency(widget.payment!.totalAmount)}',
        width: 8,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);
    bytes += generator.hr();
    bytes += generator.text(
      'Thank you for your visit!',
      styles: PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(2);
    return bytes;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentProvider.fetchCustomerName(widget.payment!.orderId);
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
                        widget.payment!.orderId,
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
                            'Total : ${formatCurrency(widget.payment!.totalAmount)}',
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
                          onPressed: _showPrinterPopup,
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
