import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/language_service.dart';
import '../models/menu_item.dart';
import '../widgets/balance_card.dart';
import 'menu_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'deposit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = '';
  double _balance = 3000.0;
  int _mealCount = 0;
  bool _loading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    appLanguage.addListener(() => setState(() {}));
  }

  String t(String en, String am) => appLanguage.t(en, am);

  Future<void> _loadData() async {
    final name = await StorageService.getName();
    final balance = await StorageService.getBalance();
    final mealCount = await StorageService.getMealCount();
    setState(() {
      _name = name;
      _balance = balance;
      _mealCount = mealCount;
      _loading = false;
    });
  }

  Future<void> _refreshData() async {
    final balance = await StorageService.getBalance();
    final mealCount = await StorageService.getMealCount();
    setState(() {
      _balance = balance;
      _mealCount = mealCount;
    });
  }

  // Show food selection bottom sheet filtered by meal type
  void _showFoodPicker(String mealTypeEn, String mealTypeAm) {
    final allFoods = getMockFoodMenu();
    // Filter by meal type category or show all for that meal time
    List<MenuItem> foods;
    if (mealTypeEn == 'Breakfast') {
      foods = allFoods.where((f) => f.categoryEn == 'Breakfast' || f.categoryEn == 'Drinks').toList();
    } else if (mealTypeEn == 'Lunch') {
      foods = allFoods.where((f) => f.categoryEn == 'Meat' || f.categoryEn == 'Stew' || f.categoryEn == 'Fasting' || f.categoryEn == 'Fish' || f.categoryEn == 'Pasta').toList();
    } else {
      // Dinner — all foods
      foods = allFoods;
    }

    final Set<int> selectedIds = {};
    double totalCost = 0;
    final Map<int, int> quantities = {}; // food id -> quantity

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t('Select your $mealTypeEn', '$mealTypeAm ምግቦችን ይምረጡ'),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                            ),
                            Text(
                              t('Choose multiple items', 'ብዙ ምግቦች መምረጥ ይችላሉ'),
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Food list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    itemCount: foods.length,
                    itemBuilder: (_, i) {
                      final food = foods[i];
                      final selected = selectedIds.contains(food.id);
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            if (selected) {
                              selectedIds.remove(food.id);
                              totalCost -= food.price * (quantities[food.id] ?? 1);
                              quantities.remove(food.id);
                            } else {
                              selectedIds.add(food.id);
                              quantities[food.id] = 1;
                              totalCost += food.price;
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected ? const Color(0xFF2E7D32) : Colors.grey.shade200,
                              width: selected ? 2 : 1,
                            ),
                            color: selected ? const Color(0xFFE8F5E9) : Colors.white,
                          ),
                          child: Row(
                            children: [
                              // Food image
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  food.image,
                                  width: 80, height: 80, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 80, height: 80, color: Colors.grey[100],
                                    child: const Icon(Icons.fastfood, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appLanguage.isAmharic ? food.titleAmharic : food.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      appLanguage.isAmharic ? food.category : food.categoryEn,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${food.price.toInt()} ${t('ETB', 'ብር')}',
                                      style: const TextStyle(
                                        color: Color(0xFFFF6F00),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity controls
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: selected
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                final qty = quantities[food.id] ?? 1;
                                                if (qty <= 1) {
                                                  selectedIds.remove(food.id);
                                                  totalCost -= food.price;
                                                  quantities.remove(food.id);
                                                } else {
                                                  quantities[food.id] = qty - 1;
                                                  totalCost -= food.price;
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 26, height: 26,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.remove, size: 14),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 6),
                                            child: Text(
                                              '${quantities[food.id] ?? 1}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                final qty = quantities[food.id] ?? 1;
                                                quantities[food.id] = qty + 1;
                                                totalCost += food.price;
                                              });
                                            },
                                            child: Container(
                                              width: 26, height: 26,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF2E7D32),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.add, size: 14, color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        width: 26, height: 26,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom confirm bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -4))],
                  ),
                  child: Column(
                    children: [
                      if (selectedIds.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                t('${selectedIds.length} item(s) selected', '${selectedIds.length} ምግብ ተመርጧል'),
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              Text(
                                t('Total: ${totalCost.toInt()} ETB', 'ጠቅላላ: ${totalCost.toInt()} ብር'),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: selectedIds.isEmpty
                              ? null
                              : () {
                                  Navigator.pop(ctx);
                                  // Build items list with quantities
                                  final List<MenuItem> itemsToOrder = [];
                                  for (final id in selectedIds) {
                                    final food = foods.firstWhere((f) => f.id == id);
                                    final qty = quantities[id] ?? 1;
                                    for (int i = 0; i < qty; i++) {
                                      itemsToOrder.add(food);
                                    }
                                  }
                                  _confirmPurchase(itemsToOrder, totalCost);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            selectedIds.isEmpty
                                ? t('Select at least one item', 'ቢያንስ አንድ ምግብ ይምረጡ')
                                : t('Order ${quantities.values.fold(0, (a, b) => a + b)} item(s) — ${totalCost.toInt()} ETB', '${quantities.values.fold(0, (a, b) => a + b)} ምግብ ይዘዙ — ${totalCost.toInt()} ብር'),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmPurchase(List<MenuItem> items, double totalCost) async {
    if (_balance < totalCost) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6F00), size: 28),
            const SizedBox(width: 8),
            Text(t('Insufficient Balance', 'በቂ ሂሳብ የለም')),
          ]),
          content: Text(t(
            'You need ${totalCost.toInt()} ETB but your balance is ${_balance.toInt()} ETB.',
            '${totalCost.toInt()} ብር ያስፈልግዎታል ነገር ግን ሂሳብዎ ${_balance.toInt()} ብር ብቻ ነው።',
          )),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final newBalance = _balance - totalCost;
    final newMealCount = _mealCount + items.length;

    // Save each item as a transaction
    for (final item in items) {
      await StorageService.addTransaction({
        'meal': item.title,
        'mealAm': item.titleAmharic,
        'amount': item.price,
        'date': DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
      });
    }
    await StorageService.updateAfterPurchase(newBalance, newMealCount);

    setState(() {
      _balance = newBalance;
      _mealCount = newMealCount;
    });

    if (mounted) {
      // Group items by name and count quantities
      final Map<String, int> itemCounts = {};
      final Map<String, String> itemCountsAm = {};
      for (final item in items) {
        final key = item.title;
        itemCounts[key] = (itemCounts[key] ?? 0) + 1;
        itemCountsAm[key] = item.titleAmharic;
      }
      final names = itemCounts.entries.map((e) {
        final label = appLanguage.isAmharic ? itemCountsAm[e.key]! : e.key;
        return e.value > 1 ? '${e.value}× $label' : label;
      }).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(t('Ordered: $names', 'ታዘዘ: $names'))),
          ]),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t('Logout', 'ውጣ')),
        content: Text(t('Are you sure you want to logout?', 'እርግጠኛ ነዎት መውጣት ይፈልጋሉ?')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t('Cancel', 'ሰርዝ'), style: const TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6F00)),
            child: Text(t('Logout', 'ውጣ')),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await StorageService.logout();
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  void _onTabTapped(int index) async {
    if (index == 1) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuScreen()));
    } else if (index == 2) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
      _refreshData();
    } else if (index == 3) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
      _refreshData();
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('UniBite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          GestureDetector(
            onTap: () => appLanguage.toggle(),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                const Icon(Icons.language, color: Colors.white, size: 15),
                const SizedBox(width: 4),
                Text(appLanguage.isAmharic ? 'EN' : 'አማ',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ]),
            ),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t('Hello, ${_name.split(' ').first} 👋', 'ሰላም፣ ${_name.split(' ').first} 👋'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
            ),
            const SizedBox(height: 4),
            Text(t('What would you like today?', 'ዛሬ ምን ይፈልጋሉ?'),
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 18),

            BalanceCard(balance: _balance, mealCount: _mealCount),
            const SizedBox(height: 12),

            // Deposit button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DepositScreen(currentBalance: _balance),
                    ),
                  );
                  if (result != null) {
                    setState(() => _balance = result as double);
                  }
                },
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2E7D32)),
                label: Text(
                  t('Deposit Funds', 'ገንዘብ ያስቀምጡ'),
                  style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(t('Order a Meal', 'ምግብ ይዘዙ'),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
            const SizedBox(height: 6),
            Text(t('Tap to browse and select multiple foods', 'ብዙ ምግቦችን ለመምረጥ ይጫኑ'),
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(child: _MealTile(
                  icon: Icons.wb_sunny_outlined,
                  label: t('Breakfast', 'ቁርስ'),
                  price: t('from 60 ETB', 'ከ60 ብር'),
                  color: const Color(0xFFFF6F00),
                  onTap: () => _showFoodPicker('Breakfast', 'ቁርስ'),
                )),
                const SizedBox(width: 12),
                Expanded(child: _MealTile(
                  icon: Icons.lunch_dining,
                  label: t('Lunch', 'ምሳ'),
                  price: t('from 80 ETB', 'ከ80 ብር'),
                  color: const Color(0xFF2E7D32),
                  onTap: () => _showFoodPicker('Lunch', 'ምሳ'),
                )),
                const SizedBox(width: 12),
                Expanded(child: _MealTile(
                  icon: Icons.nights_stay_outlined,
                  label: t('Dinner', 'እራት'),
                  price: t('all foods', 'ሁሉም ምግቦች'),
                  color: const Color(0xFF1565C0),
                  onTap: () => _showFoodPicker('Dinner', 'እራት'),
                )),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        elevation: 12,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: t('Home', 'ዋና')),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_book_outlined), activeIcon: const Icon(Icons.menu_book), label: t('Menu', 'ምናሌ')),
          BottomNavigationBarItem(icon: const Icon(Icons.receipt_long_outlined), activeIcon: const Icon(Icons.receipt_long), label: t('History', 'ታሪክ')),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: t('Profile', 'መገለጫ')),
        ],
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String price;
  final Color color;
  final VoidCallback onTap;

  const _MealTile({required this.icon, required this.label, required this.price, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(price, style: const TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Text('TAP', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
