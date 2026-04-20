import 'package:first_project/models/product_model.dart';
import 'package:first_project/screens/product_details_screen.dart';
import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_project/providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey.shade100;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: product.image.startsWith('http')
                    ? Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.broken_image),
                      )
                    : Image.asset(product.image, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.category,
              style: TextStyle(color: subTextColor, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 14),
                Text(
                  " ${product.rating} (${product.reviews} Reviews)",
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.price}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).addItem(product);
                    showTopSnackBar(context, "${product.name} added to cart!");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
