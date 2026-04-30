import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/language_service.dart';

class DepositScreen extends StatefulWidget {
  final double currentBalance;
  const DepositScreen({super.key, required this.currentBalance});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedMethod;
  bool _loading = false;
  bool _success = false;
  double _newBalance = 0;

  @override
  void initState() {
    super.initState();
    _newBalance = widget.currentBalance;
    appLanguage.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String t(String en, String am) => appLanguage.t(en, am);

  final List<Map<String, dynamic>> _methods = [
    {'id': 'cbe', 'name': 'CBE Birr', 'nameAm': 'ሲቢኢ ብር', 'color': const Color(0xFF1565C0), 'image': 'cbe.jpg'},
    {'id': 'telebirr', 'name': 'TeleBirr', 'nameAm': 'ቴሌብር', 'color': const Color(0xFF00897B), 'image': 'telebirr.webp'},
    {'id': 'mpesa', 'name': 'M-Pesa', 'nameAm': 'ኤም ፔሳ', 'color': const Color(0xFF6A1B9A), 'image': 'mpesa.png'},
    {'id': 'ebirr', 'name': 'eBirr', 'nameAm': 'ኢብር', 'color': const Color(0xFFE65100), 'image': 'ebirr.png'},
  ];

  final List<int> _quickAmounts = [100, 200, 500, 1000, 2000, 5000];

  Future<void> _deposit() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t('Please select a payment method', 'እባክዎ የክፍያ ዘዴ ይምረጡ')),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));

    final amount = double.parse(_amountController.text.trim());
    final newBalance = widget.currentBalance + amount;
    final mealCount = await StorageService.getMealCount();
    await StorageService.updateAfterPurchase(newBalance, mealCount);

    final method = _methods.firstWhere((m) => m['id'] == _selectedMethod);
    await StorageService.addTransaction({
      'meal': 'Deposit via ${method['name']}',
      'mealAm': '${method['nameAm']} በኩል ተቀማጭ',
      'amount': -amount,
      'isDeposit': true,
      'date': DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
    });

    setState(() {
      _loading = false;
      _success = true;
      _newBalance = newBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('Deposit Funds', 'ገንዘብ ያስቀምጡ'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _success ? _buildSuccess() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.white70, size: 20),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('Current Balance', 'አሁን ያለ ሂሳብ'),
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(
                      '${widget.currentBalance.toStringAsFixed(2)} ${t('ETB', 'ብር')}',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(t('Select Payment Method', 'የክፍያ ዘዴ ይምረጡ'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
          const SizedBox(height: 12),

          // Payment method row — small icons
          Row(
            children: _methods.map((method) {
              final selected = _selectedMethod == method['id'];
              final color = method['color'] as Color;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMethod = method['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? color.withOpacity(0.12) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? color : Colors.grey.shade300,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(method['image'] as String, width: 42, height: 42, fit: BoxFit.contain),
                        const SizedBox(height: 4),
                        Text(
                          appLanguage.isAmharic ? method['nameAm'] as String : method['name'] as String,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: selected ? color : Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        if (selected)
                          Icon(Icons.check_circle, color: color, size: 12),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          Text(t('Enter Amount', 'መጠን ያስገቡ'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
          const SizedBox(height: 12),

          // Quick amount chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickAmounts.map((amt) {
              final isSelected = _amountController.text == amt.toString();
              return GestureDetector(
                onTap: () => setState(() => _amountController.text = amt.toString()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
                  ),
                  child: Text(
                    '$amt ${t('ETB', 'ብር')}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          Form(
            key: _formKey,
            child: TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: t('Amount (ETB)', 'መጠን (ብር)'),
                prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF2E7D32)),
                hintText: t('e.g. 500', 'ምሳሌ፦ 500'),
                suffixText: t('ETB', 'ብር'),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return t('Enter an amount', 'መጠን ያስገቡ');
                final n = double.tryParse(v.trim());
                if (n == null || n <= 0) return t('Enter a valid amount', 'ትክክለኛ መጠን ያስገቡ');
                if (n < 10) return t('Minimum deposit is 10 ETB', 'አነስተኛ ተቀማጭ 10 ብር ነው');
                if (n > 50000) return t('Maximum deposit is 50,000 ETB', 'ከፍተኛ ተቀማጭ 50,000 ብር ነው');
                return null;
              },
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _loading ? null : _deposit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _loading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)),
                        SizedBox(width: 12),
                        Text('Processing...', style: TextStyle(color: Colors.white, fontSize: 15)),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          _amountController.text.isNotEmpty && double.tryParse(_amountController.text) != null
                              ? t('Deposit ${_amountController.text} ETB', '${_amountController.text} ብር አስቀምጥ')
                              : t('Deposit', 'አስቀምጥ'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              t('This is a simulated deposit for demo purposes.', 'ይህ ለማሳያ ዓላማ የተስሎ ተቀማጭ ነው።'),
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    final method = _methods.firstWhere((m) => m['id'] == _selectedMethod);
    final amount = double.tryParse(_amountController.text) ?? 0;
    final color = method['color'] as Color;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 60),
          ),
          const SizedBox(height: 16),
          Text(t('Deposit Successful!', 'ተቀማጭ ተሳካ!'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Image.asset(method['image'] as String, width: 48, height: 48, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            appLanguage.isAmharic ? method['nameAm'] as String : method['name'] as String,
            style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFA5D6A7)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t('Amount Deposited', 'የተቀመጠ መጠን'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('+${amount.toStringAsFixed(2)} ${t('ETB', 'ብር')}',
                        style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t('New Balance', 'አዲስ ሂሳብ'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('${_newBalance.toStringAsFixed(2)} ${t('ETB', 'ብር')}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1B5E20))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _newBalance),
              child: Text(t('Back to Home', 'ወደ ዋና ገጽ ተመለስ'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
