import 'package:flutter/material.dart';

enum FoodCategory { burgers, salads, sides, desserts, drinks }

FoodCategory stringToFoodCategory(String? category) {
  switch (category) {
    case 'burgers':
      return FoodCategory.burgers;
    case 'salads':
      return FoodCategory.salads;
    case 'sides':
      return FoodCategory.sides;
    case 'desserts':
      return FoodCategory.desserts;
    case 'drinks':
      return FoodCategory.drinks;
    default:
      debugPrint("⚠️ Unknown food category: $category, defaulting to burgers");
      return FoodCategory.burgers;
  }
}

class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory category;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
  });

  factory Food.fromMap(Map<String, dynamic> data) {
    return Food(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imagePath: data['imagePath'] ?? '',
      price: (data['price'] as num).toDouble(),
      category: stringToFoodCategory(data['category']),
    );
  }
}
