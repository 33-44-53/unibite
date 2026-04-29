import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/language_service.dart';

// Topic 5: Networking & API Integration
// - Fetches from https://fakestoreapi.com/products
// - JSON parsing, loading indicator, error handling
class ApiMenuScreen extends StatefulWidget {
  const ApiMenuScreen({super.key});

  @override
  State<ApiMenuScreen> createState() => _ApiMenuScreenState();
}

class _ApiMenuScreenState extends State<ApiMenuScreen> {
  List<ApiProduct> _products = [];
  List<ApiProduct> _filtered = [];
  bool _loading = true;
  String? _error;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetch();
    _searchController.addListener(_onSearch);
    appLanguage.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String t(String en, String am) => appLanguage.t(en, am);

  // Fetch from public API
  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final products = await ApiService.fetchProducts();
      setState(() {
        _products = products;
        _filtered = products;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _products
          .where((p) => p.title.toLowerCase().contains(q) || p.category.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Online Store', 'የኦንላይን መደብር'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetch, tooltip: t('Refresh', 'አድስ')),
        ],
      ),
      body: Column(
        children: [
          // API source badge
          Container(
            width: double.infinity,
            color: const Color(0xFFE8F5E9),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.cloud_done, color: Color(0xFF2E7D32), size: 16),
                const SizedBox(width: 8),
                Text(
                  t('Live data from fakestoreapi.com', 'ቀጥታ ውሂብ ከ fakestoreapi.com'),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF2E7D32), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: t('Search products...', 'ምርቶችን ፈልግ...'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () => _searchController.clear())
                    : null,
              ),
            ),
          ),

          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // Loading indicator (Topic 5 requirement)
    if (_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF2E7D32)),
            const SizedBox(height: 16),
            Text(t('Loading products...', 'ምርቶችን በመጫን ላይ...'),
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // Error handling (Topic 5 requirement)
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(t('Failed to load products', 'ምርቶችን መጫን አልተቻለም'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetch,
                icon: const Icon(Icons.refresh),
                label: Text(t('Try Again', 'እንደገና ሞክር')),
              ),
            ],
          ),
        ),
      );
    }

    if (_filtered.isEmpty) {
      return Center(child: Text(t('No products found', 'ምንም ምርት አልተገኘም'),
          style: const TextStyle(color: Colors.grey)));
    }

    return RefreshIndicator(
      onRefresh: _fetch,
      color: const Color(0xFF2E7D32),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        itemCount: _filtered.length,
        itemBuilder: (ctx, i) => _ProductCard(product: _filtered[i]),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ApiProduct product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image from API
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.image,
                width: 80, height: 80, fit: BoxFit.contain,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return Container(width: 80, height: 80, color: Colors.grey[100],
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
                },
                errorBuilder: (_, __, ___) => Container(width: 80, height: 80,
                    color: Colors.grey[100], child: const Icon(Icons.image_not_supported, color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(product.category,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF2E7D32))),
                  ),
                  const SizedBox(height: 6),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF6F00))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
