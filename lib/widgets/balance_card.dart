import 'package:flutter/material.dart';
import '../services/language_service.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final int mealCount;

  const BalanceCard({super.key, required this.balance, required this.mealCount});

  @override
  Widget build(BuildContext context) {
    final isAm = appLanguage.isAmharic;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20, top: -20,
            child: Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.white70, size: 18),
                  const SizedBox(width: 6),
                  Text(isAm ? 'የምግብ ሂሳብ' : 'Meal Balance',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${balance.toStringAsFixed(2)} ${isAm ? 'ብር' : 'ETB'}',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(height: 1, color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.restaurant, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    isAm
                        ? '$mealCount ምግብ${mealCount == 1 ? '' : 'ዎች'} ተገዝቷል'
                        : '$mealCount meal${mealCount == 1 ? '' : 's'} purchased',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const Spacer(),
                  if (balance < 200)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isAm ? 'ሂሳብ አነስተኛ' : 'Low Balance',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
