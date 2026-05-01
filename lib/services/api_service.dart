import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProduct {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;

  const ApiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });

  factory ApiProduct.fromMealJson(Map<String, dynamic> json, int index) {
    return ApiProduct(
      id: index,
      title: json['strMeal'] as String,
      price: 0.0,
      image: json['strMealThumb'] as String,
      category: json['strCategory'] as String? ?? 'Meal',
      description: json['strArea'] != null ? '${json['strArea']} cuisine' : 'Delicious meal',
    );
  }
}

class ApiService {
  // TheMealDB — free public API, no key needed
  static const String _url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=';

  static Future<List<ApiProduct>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> meals = data['meals'] ?? [];
      return meals
          .asMap()
          .entries
          .map((e) => ApiProduct.fromMealJson(e.value, e.key + 1))
          .toList();
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
