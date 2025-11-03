import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_order_app_flutter_firebase/models/food.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Food>> fetchFoodMenu() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('foods').get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Defensive checks for missing fields
        return Food(
          name: data['name'] ?? 'Unnamed Food',
          description: data['description'] ?? 'No description',
          imagePath: data['imagePath'] ?? '',
          price: (data['price'] is int)
              ? (data['price'] as int).toDouble()
              : (data['price'] ?? 0.0),
          category: stringToFoodCategory(
            (data['category'] ?? 'burgers').toString().toLowerCase(),
          ),
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
