import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app_flutter_firebase/models/cart_item.dart';
import 'package:food_order_app_flutter_firebase/models/food.dart';
import 'package:food_order_app_flutter_firebase/services/database/food_services.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier {
  List<Food> _menu = [];
  final List<CartItem> _cart = [];
  String _deliveryAddress = '';

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress;

  // ✅ used by homepage -> initializeMenu()
  Future<void> initializeMenu() async {
    await fetchAndStoreFoodMenu();
  }

  // ✅ used by homepage -> getFullMenu()
  List<Food> getFullMenu() {
    return _menu;
  }

  Future<void> fetchAndStoreFoodMenu() async {
    try {
      final foodService = FoodService();
      _menu = await foodService.fetchFoodMenu();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching menu: $e");
    }
  }

  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  void addToCart(Food food) {
    final cartItem = _cart.firstWhereOrNull((item) => item.food == food);
    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(CartItem(food: food, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    final index = _cart.indexOf(cartItem);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  double getTotalPrice() =>
      _cart.fold(0.0, (sum, item) => sum + item.food.price * item.quantity);

  int getTotalItemCount() => _cart.fold(0, (sum, item) => sum + item.quantity);

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  String displayCartReceipt() {
    final buffer = StringBuffer()
      ..writeln("Here's your receipt")
      ..writeln("---------------------------------------")
      ..writeln(DateFormat('yyyy-MM-dd').format(DateTime.now()))
      ..writeln("---------------------------------------");

    for (final item in _cart) {
      buffer.writeln(
        "${item.food.name} x${item.quantity} - ${_formatPrice(item.totalPrice)}",
      );
    }

    buffer
      ..writeln("---------------------------------------")
      ..writeln('Total Items: ${getTotalItemCount()}')
      ..writeln('Total: ${_formatPrice(getTotalPrice())}')
      ..writeln("Deliver to: $deliveryAddress");

    return buffer.toString();
  }

  String _formatPrice(double price) => "₹${price.toStringAsFixed(2)}";

  Map<FoodCategory, List<Food>> categorizeFoodItems() {
    return {
      for (var category in FoodCategory.values)
        category: _menu.where((f) => f.category == category).toList(),
    };
  }
}
