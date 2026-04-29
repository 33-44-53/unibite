import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/language_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    appLanguage.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  String t(String en, String am) => appLanguage.t(en, am);

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await StorageService.saveUser(
      _nameController.text.trim(),
      _idController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language toggle
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => appLanguage.toggle(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            appLanguage.isAmharic ? 'English' : 'አማርኛ',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Icon(Icons.restaurant_menu, size: 72, color: Color(0xFF2E7D32)),
                const SizedBox(height: 16),
                const Text(
                  'UniBite',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                ),
                const SizedBox(height: 6),
                Text(
                  t('Sign in to manage your meals', 'ምግብዎን ለማስተዳደር ይግቡ'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: t('Full Name', 'ሙሉ ስም'),
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: t('e.g. Abebe Kebede', 'ምሳሌ፦ አበበ ከበደ'),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return t('Please enter your name', 'እባክዎ ስምዎን ያስገቡ');
                    if (v.trim().length < 2) return t('Name must be at least 2 characters', 'ስም ቢያንስ 2 ፊደላት መሆን አለበት');
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: t('Student ID', 'የተማሪ መታወቂያ'),
                    prefixIcon: const Icon(Icons.badge_outlined),
                    hintText: t('e.g. UGR/12345/15', 'ምሳሌ፦ UGR/12345/15'),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return t('Please enter your student ID', 'እባክዎ የተማሪ መታወቂያዎን ያስገቡ');
                    if (v.trim().length < 3) return t('Enter a valid student ID', 'ትክክለኛ መታወቂያ ያስገቡ');
                    return null;
                  },
                ),
                const SizedBox(height: 36),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Text(t('Login', 'ግባ'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFA5D6A7)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          t('New students start with 3000 ETB balance.', 'አዲስ ተማሪዎች 3000 ብር ይጀምራሉ።'),
                          style: const TextStyle(fontSize: 13, color: Color(0xFF2E7D32)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
