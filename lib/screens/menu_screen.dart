import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/language_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuItem> _allItems = [];
  List<MenuItem> _filtered = [];
  String _selectedCategory = 'all';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allItems = getMockFoodMenu();
    _filtered = _allItems;
    _searchController.addListener(_onSearch);
    appLanguage.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String t(String en, String am) => appLanguage.t(en, am);

  // Category keys are English internally, displayed in current language
  List<Map<String, String>> get _categories {
    final cats = _allItems.map((e) => e.categoryEn).toSet().toList();
    return [
      {'key': 'all', 'label': t('All', 'ሁሉም')},
      ...cats.map((c) => {'key': c, 'label': t(c, _amCat(c))}),
    ];
  }

  String _amCat(String en) {
    switch (en) {
      case 'Meat': return 'ስጋ';
      case 'Stew': return 'ወጥ';
      case 'Fasting': return 'የጾም';
      case 'Breakfast': return 'ቁርስ';
      case 'Fish': return 'ዓሳ';
      case 'Drinks': return 'መጠጥ';
      case 'Pasta': return 'ፓስታ';
      default: return en;
    }
  }

  void _onSearch() => _applyFilters();

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _allItems.where((item) {
        final matchesSearch = item.title.toLowerCase().contains(query) ||
            item.titleAmharic.contains(query);
        final matchesCategory =
            _selectedCategory == 'all' || item.categoryEn == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  Color _categoryColor(String categoryEn) {
    switch (categoryEn) {
      case 'Meat': return const Color(0xFFD32F2F);
      case 'Stew': return const Color(0xFF2E7D32);
      case 'Fasting': return const Color(0xFF00796B);
      case 'Breakfast': return const Color(0xFFFF6F00);
      case 'Fish': return const Color(0xFF0277BD);
      case 'Drinks': return const Color(0xFF5D4037);
      case 'Pasta': return const Color(0xFF7B1FA2);
      default: return const Color(0xFF546E7A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Café Menu', 'የካፌ ምናሌ'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
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
                final selected = _selectedCategory == cat['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat['label']!),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat['key']!);
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
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => _MenuCard(
                      item: _filtered[i],
                      categoryColor: _categoryColor(_filtered[i].categoryEn),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItem item;
  final Color categoryColor;
  const _MenuCard({required this.item, required this.categoryColor});

  @override
  Widget build(BuildContext context) {
    final isAm = appLanguage.isAmharic;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16),
            ),
            child: Image.network(
              item.image,
              width: double.infinity, height: 160, fit: BoxFit.cover,
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(width: double.infinity, height: 160, color: Colors.grey[100],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E7D32))));
              },
              errorBuilder: (_, __, ___) => Container(width: double.infinity, height: 160,
                  color: Colors.grey[100], child: const Icon(Icons.fastfood, color: Colors.grey, size: 48)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAm ? item.titleAmharic : item.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                          ),
                          Text(
                            isAm ? item.title : item.titleAmharic,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: categoryColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        isAm ? item.category : item.categoryEn,
                        style: TextStyle(fontSize: 12, color: categoryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isAm ? item.description : item.descriptionEn,
                  style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFFF6F00), borderRadius: BorderRadius.circular(20)),
                      child: Text('${item.price.toStringAsFixed(0)} ${isAm ? 'ብር' : 'ETB'}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    const Row(children: [
                      Icon(Icons.star, color: Color(0xFFFF6F00), size: 16),
                      Icon(Icons.star, color: Color(0xFFFF6F00), size: 16),
                      Icon(Icons.star, color: Color(0xFFFF6F00), size: 16),
                      Icon(Icons.star, color: Color(0xFFFF6F00), size: 16),
                      Icon(Icons.star_half, color: Color(0xFFFF6F00), size: 16),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
