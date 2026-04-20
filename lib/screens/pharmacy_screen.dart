import 'package:first_project/components/product_card.dart';
import 'package:first_project/models/product_model.dart';
import 'package:first_project/services/data_service.dart';
import 'package:first_project/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_project/providers/cart_provider.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final List<String> categories = ["All", "Medicines", "Vitamins", "Supplements"];
  String selectedCategory = "All";
  String searchQuery = "";
  List<Product> allProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await DataService.fetchPharmacyProducts();
    if (mounted) {
      setState(() {
        allProducts = products;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final searchFill = isDark ? const Color(0xFF1E293B) : const Color.fromARGB(255, 235, 235, 235);
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade200;

    List<Product> displayedProducts = allProducts;
    if (selectedCategory != "All") {
      displayedProducts = displayedProducts.where((p) => p.category == selectedCategory).toList();
    }
    if (searchQuery.isNotEmpty) {
      displayedProducts = displayedProducts.where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
        ),
        title: Text("Pharmacy", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.shopping_cart, size: 30, color: textColor),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: -5,
                          top: -5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                cursorColor: primaryColor,
                style: TextStyle(color: textColor),
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Search here...",
                  hintStyle: TextStyle(color: subTextColor),
                  prefixIcon: Icon(Icons.search, color: subTextColor),
                  suffixIcon: Icon(Icons.qr_code_scanner, color: primaryColor),
                  filled: true,
                  fillColor: searchFill,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              if (searchQuery.isEmpty) ...[
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = categories[index] == selectedCategory;
                      return GestureDetector(
                        onTap: () { setState(() { selectedCategory = categories[index]; }); },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? primaryColor : borderColor),
                          ),
                          child: Text(categories[index], style: TextStyle(color: isSelected ? Colors.white : subTextColor, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Text(selectedCategory == "All" ? "All Products" : selectedCategory, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              ],
              const SizedBox(height: 15),
              isLoading 
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : displayedProducts.isEmpty 
                    ? Center(child: Text("No products found", style: TextStyle(color: subTextColor)))
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 10, mainAxisSpacing: 10),
                        itemCount: displayedProducts.length,
                        itemBuilder: (context, index) => ProductCard(product: displayedProducts[index]),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}