import 'package:food_order_app_flutter_firebase/models/food.dart';

class CartItem {
  final Food food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});

  double get totalPrice => food.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'food': {
        'name': food.name,
        'description': food.description,
        'imagePath': food.imagePath,
        'price': food.price,
        'category': food.category.name,
      },
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      food: Food.fromMap(data['food']),
      quantity: data['quantity'] ?? 1,
    );
  }
}
