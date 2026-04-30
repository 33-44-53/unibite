import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/language_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    appLanguage.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String t(String en, String am) => appLanguage.t(en, am);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
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
                        const Icon(Icons.language, color: Colors.white, size: 15),
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

              // Logo + title
              const Icon(Icons.restaurant_menu, size: 64, color: Color(0xFF2E7D32)),
              const SizedBox(height: 12),
              const Text(
                'UniBite',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 6),
              Text(
                t('Your Campus Meal Companion', 'የካምፓስ ምግብ ጓደኛዎ'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF2E7D32),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: t('Login', 'ግባ')),
                    Tab(text: t('Register', 'ተመዝገብ')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tab views
              SizedBox(
                height: 380,
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    _LoginForm(),
                    _RegisterForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Login Form ────────────────────────────────────────────────────────────────
class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  String t(String en, String am) => appLanguage.t(en, am);

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final exists = await StorageService.accountExists(_idController.text.trim());
    if (!exists) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t('No account found. Please register first.', 'መለያ አልተገኘም። እባክዎ ይመዝገቡ።')),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ));
      }
      return;
    }

    final success = await StorageService.login(
      _idController.text.trim(),
      _passController.text.trim(),
    );

    setState(() => _loading = false);

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t('Wrong password. Try again.', 'የተሳሳተ የይለፍ ቃል። እንደገና ሞክር።')),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: t('Student ID', 'የተማሪ መታወቂያ'),
              prefixIcon: const Icon(Icons.badge_outlined),
              hintText: 'e.g. UGR/12345/15',
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? t('Enter your student ID', 'የተማሪ መታወቂያ ያስገቡ')
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: t('Password', 'የይለፍ ቃል'),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? t('Enter your password', 'የይለፍ ቃል ያስገቡ')
                : null,
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : Text(t('Login', 'ግባ'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFA5D6A7)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t('No account yet? Switch to Register tab.', 'መለያ የለዎትም? ወደ ተመዝገብ ትር ይቀይሩ።'),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Register Form ─────────────────────────────────────────────────────────────
class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;

  String t(String en, String am) => appLanguage.t(en, am);

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final exists = await StorageService.accountExists(_idController.text.trim());
    if (exists) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t('This Student ID is already registered.', 'ይህ የተማሪ መታወቂያ አስቀድሞ ተመዝግቧል።')),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ));
      }
      return;
    }

    await StorageService.register(
      _nameController.text.trim(),
      _idController.text.trim(),
      _passController.text.trim(),
    );

    setState(() => _loading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(t('Account created! Welcome to UniBite 🎉', 'መለያ ተፈጠረ! ወደ UniBite እንኳን ደህና መጡ 🎉')),
      backgroundColor: const Color(0xFF2E7D32),
      behavior: SnackBarBehavior.floating,
    ));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: t('Full Name', 'ሙሉ ስም'),
                prefixIcon: const Icon(Icons.person_outline),
                hintText: t('e.g. Abebe Kebede', 'ምሳሌ፦ አበበ ከበደ'),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return t('Enter your name', 'ስምዎን ያስገቡ');
                if (v.trim().length < 2) return t('Name too short', 'ስም በጣም አጭር ነው');
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: t('Student ID', 'የተማሪ መታወቂያ'),
                prefixIcon: const Icon(Icons.badge_outlined),
                hintText: 'e.g. UGR/12345/15',
              ),
              validator: (v) => v == null || v.trim().length < 3
                  ? t('Enter a valid student ID', 'ትክክለኛ መታወቂያ ያስገቡ')
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: t('Password', 'የይለፍ ቃል'),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return t('Enter a password', 'የይለፍ ቃል ያስገቡ');
                if (v.trim().length < 4) return t('Password must be at least 4 characters', 'የይለፍ ቃል ቢያንስ 4 ፊደላት');
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: t('Confirm Password', 'የይለፍ ቃል ያረጋግጡ'),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (v) => v != _passController.text
                  ? t('Passwords do not match', 'የይለፍ ቃሎች አይዛመዱም')
                  : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _register,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6F00)),
                child: _loading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text(t('Create Account', 'መለያ ፍጠር'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
