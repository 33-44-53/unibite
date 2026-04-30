import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  int _currentFeature = 0;

  final List<Map<String, String>> _features = [
    {
      'icon': '🍽️',
      'titleEn': 'Order Any Meal',
      'titleAm': 'ማንኛውም ምግብ ይዘዙ',
      'subEn': 'Breakfast, Lunch & Dinner from our café',
      'subAm': 'ቁርስ፣ ምሳ እና እራት ከካፌያችን',
    },
    {
      'icon': '💰',
      'titleEn': 'Track Your Balance',
      'titleAm': 'ሂሳብዎን ይከታተሉ',
      'subEn': 'Always know how much you have left',
      'subAm': 'ምን ያህል እንደቀረዎ ሁልጊዜ ያውቁ',
    },
    {
      'icon': '📋',
      'titleEn': 'Full History',
      'titleAm': 'ሙሉ ታሪክ',
      'subEn': 'See every meal you have purchased',
      'subAm': 'የገዙትን ሁሉ ምግብ ይመልከቱ',
    },
    {
      'icon': '🌐',
      'titleEn': 'Live Menu',
      'titleAm': 'ቀጥታ ምናሌ',
      'subEn': 'Browse our full café menu anytime',
      'subAm': 'የካፌ ምናሌያችንን በማንኛውም ጊዜ ይመልከቱ',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      setState(() => _currentFeature = (_currentFeature + 1) % _features.length);
      return true;
    });

    appLanguage.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String t(String en, String am) => appLanguage.t(en, am);

  @override
  Widget build(BuildContext context) {
    final feature = _features[_currentFeature];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Language toggle
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => appLanguage.toggle(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                  const SizedBox(height: 30),

                  // Logo
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.restaurant_menu, size: 54, color: Color(0xFF2E7D32)),
                  ),
                  const SizedBox(height: 20),

                  // App name
                  const Text(
                    'UniBite',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t('Your Campus Meal Companion', 'የካምፓስ ምግብ ጓደኛዎ'),
                    style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.85)),
                  ),
                  const SizedBox(height: 12),

                  // Orange divider
                  Container(
                    width: 60, height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6F00),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Animated feature card
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: child,
                    ),
                    child: Container(
                      key: ValueKey(_currentFeature),
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          Text(feature['icon']!, style: const TextStyle(fontSize: 44)),
                          const SizedBox(height: 12),
                          Text(
                            t(feature['titleEn']!, feature['titleAm']!),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t(feature['subEn']!, feature['subAm']!),
                            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_features.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentFeature == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentFeature == i ? const Color(0xFFFF6F00) : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 36),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatBadge(value: '15+', label: t('Menu Items', 'ምናሌ ምግቦች')),
                      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
                      _StatBadge(value: '3', label: t('Meal Times', 'የምግብ ጊዜዎች')),
                      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
                      _StatBadge(value: '4', label: t('Payments', 'ክፍያዎች')),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6F00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(t('Get Started', 'ጀምር'),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward_rounded, size: 22),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sign in link
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Text(
                      t('Already have an account? Sign In', 'መለያ አለዎት? ይግቡ'),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.75))),
      ],
    );
  }
}
