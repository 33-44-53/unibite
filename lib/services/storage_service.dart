import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Keys used in SharedPreferences
const String _keyName = 'student_name';
const String _keyId = 'student_id';
const String _keyBalance = 'balance';
const String _keyMealCount = 'meal_count';
const String _keyTransactions = 'transactions';
const String _keyPhotoPath = 'photo_path';

class StorageService {
  // ── Save user on login ──────────────────────────────────────────────────────
  static Future<void> saveUser(String name, String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyId, studentId);
    // Only set defaults if not already present (first login)
    if (!prefs.containsKey(_keyBalance)) {
      await prefs.setDouble(_keyBalance, 3000.0);
    }
    if (!prefs.containsKey(_keyMealCount)) {
      await prefs.setInt(_keyMealCount, 0);
    }
  }

  // ── Check if user is already logged in ─────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyName);
  }

  // ── Read stored values ──────────────────────────────────────────────────────
  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName) ?? '';
  }

  static Future<String> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyId) ?? '';
  }

  static Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyBalance) ?? 3000.0;
  }

  static Future<int> getMealCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMealCount) ?? 0;
  }

  // ── Update balance and meal count after a purchase ──────────────────────────
  static Future<void> updateAfterPurchase(
      double newBalance, int newMealCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyBalance, newBalance);
    await prefs.setInt(_keyMealCount, newMealCount);
  }

  // ── Transaction history stored as JSON-encoded list of maps ─────────────────
  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyTransactions);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> addTransaction(Map<String, dynamic> tx) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getTransactions();
    list.insert(0, tx); // newest first
    await prefs.setString(_keyTransactions, jsonEncode(list));
  }

  // ── Profile photo path (device storage) ─────────────────────────────────────
  static Future<void> savePhotoPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhotoPath, path);
  }

  static Future<String?> getPhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhotoPath);
  }

  // ── Clear everything (reset / logout) ──────────────────────────────────────
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
