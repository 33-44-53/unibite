import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/language_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    appLanguage.addListener(() => setState(() {}));
  }

  String t(String en, String am) => appLanguage.t(en, am);

  Future<void> _loadHistory() async {
    final txs = await StorageService.getTransactions();
    setState(() {
      _transactions = txs;
      _loading = false;
    });
  }

  IconData _mealIcon(String meal) {
    switch (meal) {
      case 'Breakfast': return Icons.wb_sunny_outlined;
      case 'Lunch': return Icons.lunch_dining;
      case 'Dinner': return Icons.nights_stay_outlined;
      default: return Icons.fastfood;
    }
  }

  Color _mealColor(String meal) {
    switch (meal) {
      case 'Breakfast': return const Color(0xFFFF6F00);
      case 'Lunch': return const Color(0xFF2E7D32);
      case 'Dinner': return const Color(0xFF1565C0);
      default: return Colors.grey;
    }
  }

  String _mealLabel(Map<String, dynamic> tx) {
    if (appLanguage.isAmharic) {
      return tx['mealAm'] as String? ?? tx['meal'] as String;
    }
    return tx['meal'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Transaction History', 'የግብይት ታሪክ'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? _buildEmpty()
              : _buildList(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          Text(t('No transactions yet', 'እስካሁን ምንም ግብይት የለም'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(t('Your meal purchases will appear here.', 'የምግብ ግዢዎችዎ እዚህ ይታያሉ።'),
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF43A047)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t('Total Transactions', 'ጠቅላላ ግብይቶች'),
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
              Text('${_transactions.length} ${t('meals', 'ምግቦች')}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: _transactions.length,
            itemBuilder: (ctx, i) {
              final tx = _transactions[i];
              final meal = tx['meal'] as String;
              final amount = (tx['amount'] as num).toDouble();
              final date = tx['date'] as String;
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _mealColor(meal).withOpacity(0.15),
                    child: Icon(_mealIcon(meal), color: _mealColor(meal), size: 22),
                  ),
                  title: Text(_mealLabel(tx), style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  trailing: Text('-${amount.toInt()} ${t('ETB', 'ብር')}',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
