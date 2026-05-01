import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/language_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ApiProduct> _allItems = [];
  List<ApiProduct> _filtered = [];
  String _selectedCategory = 'all';
  bool _loading = true;
  String? _error;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetch();
    _searchController.addListener(_applyFilters);
    appLanguage.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String t(String en, String am) => appLanguage.t(en, am);

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final items = await ApiService.fetchMenuMeals();
      setState(() {
        _allItems = items;
        _filtered = items;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<String> get _categories =>
      ['all', ..._allItems.map((e) => e.category).toSet().toList()];

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _allItems.where((item) {
        final matchesSearch = item.title.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'all' || item.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Chicken': return const Color(0xFFFF6F00);
      case 'Beef': return const Color(0xFFD32F2F);
      case 'Seafood': return const Color(0xFF0277BD);
      case 'Vegetarian': return const Color(0xFF2E7D32);
      case 'Breakfast': return const Color(0xFF7B1FA2);
      default: return const Color(0xFF546E7A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Café Menu', 'የካፌ ምናሌ'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetch),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(t('Failed to load menu', 'ምናሌ መጫን አልተቻለም'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _fetch,
                        icon: const Icon(Icons.refresh),
                        label: Text(t('Try Again', 'እንደገና ሞክር')),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Search
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: t('Search food...', 'ምግብ ፈልግ...'),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(icon: const Icon(Icons.clear), onPressed: () => _searchController.clear())
                              : null,
                        ),
                      ),
                    ),

                    // Category chips
                    SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _categories.length,
                        itemBuilder: (ctx, i) {
                          final cat = _categories[i];
                          final selected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat == 'all' ? t('All', 'ሁሉም') : cat),
                              selected: selected,
                              onSelected: (_) {
                                setState(() => _selectedCategory = cat);
                                _applyFilters();
                              },
                              selectedColor: const Color(0xFF2E7D32),
                              labelStyle: TextStyle(
                                color: selected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              checkmarkColor: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),

                    // Count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Row(children: [
                        Text('${_filtered.length} ${t('items available', 'ምግቦች ይገኛሉ')}',
                            style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ]),
                    ),

                    // List
                    Expanded(
                      child: _filtered.isEmpty
                          ? Center(child: Text(t('No items found', 'ምንም ምግብ አልተገኘም'),
                              style: const TextStyle(color: Colors.grey, fontSize: 16)))
                          : RefreshIndicator(
                              onRefresh: _fetch,
                              color: const Color(0xFF2E7D32),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                itemCount: _filtered.length,
                                itemBuilder: (ctx, i) => _MenuCard(
                                  item: _filtered[i],
                                  categoryColor: _categoryColor(_filtered[i].category),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final ApiProduct item;
  final Color categoryColor;
  const _MenuCard({required this.item, required this.categoryColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.image,
                width: 80, height: 80, fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return Container(width: 80, height: 80, color: Colors.grey[100],
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E7D32))));
                },
                errorBuilder: (_, __, ___) => Container(width: 80, height: 80,
                    color: Colors.grey[100], child: const Icon(Icons.fastfood, color: Colors.grey, size: 36)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: categoryColor.withOpacity(0.4)),
                        ),
                        child: Text(item.category,
                            style: TextStyle(fontSize: 11, color: categoryColor, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(children: [
                    Icon(Icons.star, color: Color(0xFFFF6F00), size: 14),
                    Icon(Icons.star, color: Color(0xFFFF6F00), size: 14),
                    Icon(Icons.star, color: Color(0xFFFF6F00), size: 14),
                    Icon(Icons.star, color: Color(0xFFFF6F00), size: 14),
                    Icon(Icons.star_half, color: Color(0xFFFF6F00), size: 14),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
