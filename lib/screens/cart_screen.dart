import 'package:first_project/components/cart_item_card.dart';
import 'package:first_project/components/price_summary.dart';
import 'package:first_project/models/cart_item_model.dart';
import 'package:first_project/screens/checkout_screen.dart';
import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:first_project/providers/cart_provider.dart';
import 'package:first_project/providers/rewards_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _pointsController = TextEditingController();

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: Text("My Cart", style: TextStyle(color: textColor)), centerTitle: true, backgroundColor: bgColor, elevation: 0),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          final items = cart.items.values.toList();
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: items.isEmpty
                      ? Center(child: Text("Your cart is empty", style: TextStyle(color: textColor, fontSize: 16)))
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            return CartItemCard(item: items[i]);
                          },
                        ),
                ),
                const SizedBox(height: 10),
            Text("Earned Points", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pointsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(color: textColor),
                        enabled: items.isNotEmpty && cart.appliedPoints == 0,
                        decoration: InputDecoration(
                          hintText: "Enter points...",
                          hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: items.isEmpty
                          ? null
                          : () {
                              if (cart.appliedPoints > 0) {
                                // Remove applied points
                                cart.applyPoints(0);
                                _pointsController.clear();
                                showTopSnackBar(context, "Cleared applied points.");
                              } else {
                                final availablePoints = Provider.of<RewardsProvider>(context, listen: false).points;
                                final points = int.tryParse(_pointsController.text) ?? 0;
                                if (points <= 0) return;
                                
                                if (points > availablePoints) {
                                  showTopSnackBar(context, "Error: You only have $availablePoints points available!");
                                  return;
                                }
                                cart.applyPoints(points);
                                showTopSnackBar(context, "Applied $points points!");
                                FocusScope.of(context).unfocus();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cart.appliedPoints > 0 ? Colors.red : primaryColor,
                        disabledBackgroundColor: Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(cart.appliedPoints > 0 ? "Remove" : "Apply", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                PriceSummary(info: PartPrice(label: "Product", value: "${cart.itemCount} items")),
                PriceSummary(info: PartPrice(label: "Subtotal", value: "\$${cart.subtotalAmount.toStringAsFixed(2)}")),
                if (cart.appliedPoints > 0)
                  PriceSummary(info: PartPrice(label: "Points Discount", value: "-\$${cart.discountAmount.toStringAsFixed(2)}")),
                PriceSummary(info: PartPrice(label: "TOTAL", value: "\$${cart.totalAmount.toStringAsFixed(2)}", isTotal: true)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: items.isEmpty ? null : () { Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen())); },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}