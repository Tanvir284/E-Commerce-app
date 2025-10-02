import 'dart:async';

class PaymentsService {
  // Mock payment processor for demo purposes. Replace with Stripe/PayPal SDK later.
  static Future<String> processMockPayment({required double amount, required Map<String, String> card}) async {
    // Simulate network/payment latency
    await Future.delayed(const Duration(seconds: 2));
    // Return a mock payment id
    return 'mock_pay_' + DateTime.now().millisecondsSinceEpoch.toString();
  }
}