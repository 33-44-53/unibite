import 'dart:convert';
import 'package:http/http.dart' as http;

// Represents a product fetched from FakeStore API
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

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }
}

class ApiService {
  static const String _url = 'https://fakestoreapi.com/products';

  // Fetch all products — used in ApiMenuScreen (Topic 5)
  static Future<List<ApiProduct>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((j) => ApiProduct.fromJson(j)).toList();
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
