import 'package:first_project/components/price_summary.dart';
import 'package:first_project/models/order_model.dart';
import 'package:first_project/models/cart_item_model.dart';
import 'package:first_project/screens/order_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_project/providers/cart_provider.dart';
import 'package:first_project/providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _address = "Rumah Kedua (+628123456789)\nJalan Bunga No 7, RT 02 RW 01\nKOTA BARU, JAWA BARAT";
  String _paymentMethod = "Cash";

  void _editAddressDialog() {
    final TextEditingController addressController = TextEditingController(text: _address);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Delivery Address"),
          content: TextField(
            controller: addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your full address",
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _address = addressController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          final subtotal = cart.subtotalAmount;
          final discount = cart.discountAmount;
          const shipping = 10.0;
          final finalTotal = (cart.totalAmount + shipping).clamp(0.0, double.infinity);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Address", textColor),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(_address, style: TextStyle(color: textColor, height: 1.4))),
                      GestureDetector(
                        onTap: _editAddressDialog,
                        child: Icon(Icons.edit_note, color: primaryColor, size: 30),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                _sectionTitle("Payment Methods", textColor),
                ListTile(
                  onTap: () => setState(() => _paymentMethod = "Cash"),
                  tileColor: cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  leading: Icon(Icons.attach_money_rounded, color: _paymentMethod == "Cash" ? primaryColor : subTextColor),
                  title: Text("Cash", style: TextStyle(color: textColor)),
                  trailing: Icon(_paymentMethod == "Cash" ? Icons.radio_button_checked : Icons.radio_button_off, color: _paymentMethod == "Cash" ? primaryColor : subTextColor),
                ),
                const SizedBox(height: 8),
                ListTile(
                  onTap: () => setState(() => _paymentMethod = "Visa"),
                  tileColor: cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  leading: Icon(Icons.credit_card, color: _paymentMethod == "Visa" ? primaryColor : subTextColor),
                  title: Text("Visa", style: TextStyle(color: textColor)),
                  trailing: Icon(_paymentMethod == "Visa" ? Icons.radio_button_checked : Icons.radio_button_off, color: _paymentMethod == "Visa" ? primaryColor : subTextColor),
                ),
                const SizedBox(height: 20),
                
                _sectionTitle("Order Summary", textColor),
                PriceSummary(info: PartPrice(label: "Subtotal", value: "\$${subtotal.toStringAsFixed(2)}")),
                if (discount > 0)
                  PriceSummary(info: PartPrice(label: "Points Discount", value: "-\$${discount.toStringAsFixed(2)}")),
                PriceSummary(info: PartPrice(label: "Shipping", value: "\$${shipping.toStringAsFixed(2)}")),
                const Divider(height: 30),
                PriceSummary(info: PartPrice(label: "Total", value: "\$${finalTotal.toStringAsFixed(2)}", isTotal: true)),
                
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Generate pseudo order Id
                    final String rawOrderId = DateTime.now().millisecondsSinceEpoch.toString();
                    final String safeOrderId = rawOrderId.substring(rawOrderId.length - 6);

                    // Produce OrderModel and push to MyOrders
                    final newOrder = OrderModel(
                      orderId: safeOrderId,
                      itemsCount: cart.itemCount,
                      price: finalTotal.toStringAsFixed(2),
                      status: "Pending",
                      statusColor: const Color(0xFFFFF3E0),
                      statusTextColor: const Color(0xFFFFB74D),
                      date: "Just Now",
                    );

                    Provider.of<OrderProvider>(context, listen: false).addOrder(newOrder);

                    // Proceed to Invoice
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderSuccessScreen(
                          orderId: safeOrderId,
                          address: _address,
                          paymentMethod: _paymentMethod,
                          itemsCount: cart.itemCount,
                          subtotal: subtotal,
                          discount: discount,
                          total: finalTotal,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: const Text("Place Order", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, Color textColor) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)));
  }
}