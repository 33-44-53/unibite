import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyAccounts = 'accounts';
const String _keyLoggedInId = 'logged_in_id';
const String _keyPhotoPath = 'photo_path';

class StorageService {

  // ── Get all registered accounts ─────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyAccounts);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  static Future<void> _saveAccounts(List<Map<String, dynamic>> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccounts, jsonEncode(accounts));
  }

  // ── Check if student ID already registered ──────────────────────────────────
  static Future<bool> accountExists(String studentId) async {
    final accounts = await getAccounts();
    return accounts.any((a) => a['studentId'] == studentId);
  }

  // ── Register new account ────────────────────────────────────────────────────
  static Future<void> register(String name, String studentId, String password) async {
    final accounts = await getAccounts();
    accounts.add({
      'name': name,
      'studentId': studentId,
      'password': password,
      'balance': 0.0,
      'mealCount': 0,
      'transactions': [],
      'photoPath': null,
    });
    await _saveAccounts(accounts);
    await _setLoggedIn(studentId);
  }

  // ── Login with studentId + password ─────────────────────────────────────────
  static Future<bool> login(String studentId, String password) async {
    final accounts = await getAccounts();
    final match = accounts.where(
      (a) => a['studentId'] == studentId && a['password'] == password,
    );
    if (match.isEmpty) return false;
    await _setLoggedIn(studentId);
    return true;
  }

  static Future<void> _setLoggedIn(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLoggedInId, studentId);
  }

  // ── Get currently logged in account ─────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyLoggedInId);
  }

  static Future<Map<String, dynamic>?> _getCurrentAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyLoggedInId);
    if (id == null) return null;
    final accounts = await getAccounts();
    final match = accounts.where((a) => a['studentId'] == id);
    return match.isEmpty ? null : match.first;
  }

  static Future<void> _updateCurrentAccount(Map<String, dynamic> updated) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyLoggedInId);
    final accounts = await getAccounts();
    final index = accounts.indexWhere((a) => a['studentId'] == id);
    if (index != -1) {
      accounts[index] = updated;
      await _saveAccounts(accounts);
    }
  }

  // ── Read current user values ─────────────────────────────────────────────────
  static Future<String> getName() async {
    final acc = await _getCurrentAccount();
    return acc?['name'] ?? '';
  }

  static Future<String> getStudentId() async {
    final acc = await _getCurrentAccount();
    return acc?['studentId'] ?? '';
  }

  static Future<double> getBalance() async {
    final acc = await _getCurrentAccount();
    return (acc?['balance'] as num?)?.toDouble() ?? 0.0;
  }

  static Future<int> getMealCount() async {
    final acc = await _getCurrentAccount();
    return (acc?['mealCount'] as int?) ?? 0;
  }

  // ── Update balance and meal count ────────────────────────────────────────────
  static Future<void> updateAfterPurchase(double newBalance, int newMealCount) async {
    final acc = await _getCurrentAccount();
    if (acc == null) return;
    acc['balance'] = newBalance;
    acc['mealCount'] = newMealCount;
    await _updateCurrentAccount(acc);
  }

  // ── Transactions ─────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final acc = await _getCurrentAccount();
    if (acc == null) return [];
    return (acc['transactions'] as List).cast<Map<String, dynamic>>();
  }

  static Future<void> addTransaction(Map<String, dynamic> tx) async {
    final acc = await _getCurrentAccount();
    if (acc == null) return;
    final list = (acc['transactions'] as List).cast<Map<String, dynamic>>();
    list.insert(0, tx);
    acc['transactions'] = list;
    await _updateCurrentAccount(acc);
  }

  // ── Profile photo ─────────────────────────────────────────────────────────────
  static Future<void> savePhotoPath(String path) async {
    final acc = await _getCurrentAccount();
    if (acc == null) return;
    acc['photoPath'] = path;
    await _updateCurrentAccount(acc);
  }

  static Future<String?> getPhotoPath() async {
    final acc = await _getCurrentAccount();
    return acc?['photoPath'] as String?;
  }

  // ── Logout (keep account data, just remove session) ──────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedInId);
  }

  // ── Reset current account data only ──────────────────────────────────────────
  static Future<void> resetCurrentAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyLoggedInId);
    final accounts = await getAccounts();
    final index = accounts.indexWhere((a) => a['studentId'] == id);
    if (index != -1) {
      final name = accounts[index]['name'];
      final password = accounts[index]['password'];
      accounts[index] = {
        'name': name,
        'studentId': id,
        'password': password,
        'balance': 0.0,
        'mealCount': 0,
        'transactions': [],
        'photoPath': null,
      };
      await _saveAccounts(accounts);
    }
    await prefs.remove(_keyLoggedInId);
  }

  // ── Legacy clearAll (used by reset in profile) ────────────────────────────────
  static Future<void> clearAll() async {
    await resetCurrentAccount();
  }
}
