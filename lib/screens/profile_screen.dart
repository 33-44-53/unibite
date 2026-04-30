import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/storage_service.dart';
import '../services/language_service.dart';
import '../screens/api_menu_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _studentId = '';
  double _balance = 0;
  int _mealCount = 0;
  bool _loading = true;
  String? _photoPath; // device photo path (Topic 6)

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
    appLanguage.addListener(() => setState(() {}));
  }

  String t(String en, String am) => appLanguage.t(en, am);

  Future<void> _loadProfile() async {
    final name = await StorageService.getName();
    final id = await StorageService.getStudentId();
    final balance = await StorageService.getBalance();
    final meals = await StorageService.getMealCount();
    final photo = await StorageService.getPhotoPath();
    setState(() {
      _name = name;
      _studentId = id;
      _balance = balance;
      _mealCount = meals;
      _photoPath = photo;
      _loading = false;
    });
  }

  // Topic 6: Camera access with permission handling
  Future<void> _pickPhoto(ImageSource source) async {
    Navigator.pop(context); // close bottom sheet

    // Request permission
    Permission permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    final status = await permission.request();

    if (status.isGranted) {
      try {
        final picked = await _picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 400,
        );
        if (picked != null) {
          await StorageService.savePhotoPath(picked.path);
          setState(() => _photoPath = picked.path);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t('Profile photo updated!', 'የመገለጫ ፎቶ ተዘምኗል!')),
                backgroundColor: const Color(0xFF2E7D32),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t('Could not access camera/gallery', 'ካሜራ/ጋለሪ መክፈት አልተቻለም')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied — open app settings
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(t('Permission Required', 'ፈቃድ ያስፈልጋል')),
            content: Text(t(
              'Camera/Gallery permission was denied. Please enable it in app settings.',
              'የካሜራ/ጋለሪ ፈቃድ ተከልክሏል። እባክዎ በቅንብሮች ውስጥ ያንቁ።',
            )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t('Cancel', 'ሰርዝ')),
              ),
              ElevatedButton(
                onPressed: () { Navigator.pop(ctx); openAppSettings(); },
                child: Text(t('Open Settings', 'ቅንብሮችን ክፈት')),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t('Permission denied', 'ፈቃድ ተከልክሏል')),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t('Update Profile Photo', 'የመገለጫ ፎቶ ቀይር'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF2E7D32),
                  child: Icon(Icons.camera_alt, color: Colors.white),
                ),
                title: Text(t('Take Photo', 'ፎቶ አንሳ')),
                subtitle: Text(t('Use camera', 'ካሜራ ተጠቀም')),
                onTap: () => _pickPhoto(ImageSource.camera),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFF6F00),
                  child: Icon(Icons.photo_library, color: Colors.white),
                ),
                title: Text(t('Choose from Gallery', 'ከጋለሪ ምረጥ')),
                subtitle: Text(t('Pick existing photo', 'ያለ ፎቶ ምረጥ')),
                onTap: () => _pickPhoto(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6F00), size: 26),
          const SizedBox(width: 8),
          Text(t('Reset Account', 'መለያ ዳግም ጀምር')),
        ]),
        content: Text(t(
          'This will clear all your data including balance and transaction history.',
          'ይህ ሂሳብዎን እና የግብይት ታሪክዎን ጨምሮ ሁሉንም ውሂብዎን ያጸዳል።',
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('Cancel', 'ሰርዝ'), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(t('Reset', 'ዳግም ጀምር')),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await StorageService.resetCurrentAccount();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(t('My Profile', 'የእኔ መገለጫ'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Profile photo with camera button (Topic 6)
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _showPhotoOptions,
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: const Color(0xFF2E7D32),
                    backgroundImage: _photoPath != null && File(_photoPath!).existsSync()
                        ? FileImage(File(_photoPath!))
                        : null,
                    child: _photoPath == null || !File(_photoPath!).existsSync()
                        ? Text(
                            _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                            style: const TextStyle(fontSize: 44, color: Colors.white, fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: _showPhotoOptions,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6F00),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _showPhotoOptions,
              icon: const Icon(Icons.edit, size: 14, color: Color(0xFF2E7D32)),
              label: Text(t('Change Photo', 'ፎቶ ቀይር'),
                  style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 13)),
            ),
            const SizedBox(height: 8),
            Text(_name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_studentId, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 24),

            // Info cards
            _InfoCard(icon: Icons.account_balance_wallet_outlined, label: t('Current Balance', 'አሁን ያለ ሂሳብ'), value: '${_balance.toStringAsFixed(2)} ${t('ETB', 'ብር')}', color: const Color(0xFF2E7D32)),
            const SizedBox(height: 12),
            _InfoCard(icon: Icons.restaurant_outlined, label: t('Total Meals Purchased', 'ጠቅላላ የተገዙ ምግቦች'), value: '$_mealCount ${t('meals', 'ምግቦች')}', color: const Color(0xFFFF6F00)),
            const SizedBox(height: 12),
            _InfoCard(icon: Icons.person_outline, label: t('Student Name', 'የተማሪ ስም'), value: _name, color: const Color(0xFF546E7A)),
            const SizedBox(height: 12),
            _InfoCard(icon: Icons.badge_outlined, label: t('Student ID', 'የተማሪ መታወቂያ'), value: _studentId, color: const Color(0xFF1565C0)),
            const SizedBox(height: 20),

            // Online store button (links to API screen - Topic 5)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApiMenuScreen())),
                icon: const Icon(Icons.store_outlined, color: Color(0xFF2E7D32)),
                label: Text(t('Browse Online Store (API)', 'የኦንላይን መደብር (API)'),
                    style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Reset button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _resetAccount,
                icon: const Icon(Icons.restart_alt),
                label: Text(t('Reset Account', 'መለያ ዳግም ጀምር'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t('Resetting will clear all data and return you to login.', 'ዳግም ማስጀመር ሁሉንም ውሂብ ያጸዳል።'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
