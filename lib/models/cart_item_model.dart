class CartItem {
  final String name;
  final String image;
  final double price;
  final double? oldPrice; // للسعر قبل الخصم
  final int quantity;
  final String category;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.oldPrice,
    required this.quantity,
    required this.category,
  });
}



class PartPrice{
  final String label;
  final String value;
  final bool isTotal;

  PartPrice({ 
    required this.label, 
    required this.value, 
    this.isTotal = false, // القيمة الافتراضية false
  });
}