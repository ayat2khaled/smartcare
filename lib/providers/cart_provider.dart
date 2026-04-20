import 'package:first_project/models/cart_item_model.dart';
import 'package:first_project/models/product_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  int _appliedPoints = 0;

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get appliedPoints => _appliedPoints;

  void applyPoints(int points) {
    _appliedPoints = points;
    notifyListeners();
  }

  int get itemCount {
    var count = 0;
    _items.forEach((key, item) {
      count += item.quantity;
    });
    return count;
  }

  double get subtotalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  double get discountAmount {
    return _appliedPoints * 0.02;
  }

  double get totalAmount {
    double finalTotal = subtotalAmount - discountAmount;
    return finalTotal < 0 ? 0.0 : finalTotal;
  }

  void addItem(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.name)) {
      _items.update(
        product.name,
        (existingCartItem) => CartItem(
          name: existingCartItem.name,
          image: existingCartItem.image,
          price: existingCartItem.price,
          oldPrice: existingCartItem.oldPrice,
          category: existingCartItem.category,
          quantity: existingCartItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.name,
        () => CartItem(
          name: product.name,
          image: product.image,
          category: product.category,
          price: product.price,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    _items.update(
      productId,
      (existingItem) => CartItem(
        name: existingItem.name,
        image: existingItem.image,
        price: existingItem.price,
        oldPrice: existingItem.oldPrice,
        category: existingItem.category,
        quantity: existingItem.quantity + 1,
      ),
    );
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          name: existingItem.name,
          image: existingItem.image,
          price: existingItem.price,
          oldPrice: existingItem.oldPrice,
          category: existingItem.category,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _appliedPoints = 0;
    notifyListeners();
  }
}
