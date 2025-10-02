import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_provider.dart';

class OrderItem {
  final String id;
  final List<CartItem> items;
  final double amount;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic> shippingAddress;

  OrderItem({
    required this.id,
    required this.items,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
  });
}

class OrdersProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<OrderItem> _orders = [];
  String? _userId;

  List<OrderItem> get orders => [..._orders];

  void setUserId(String? uid) {
    _userId = uid;
    if (_userId != null) {
      fetchOrders();
    } else {
      _orders.clear();
      notifyListeners();
    }
  }

  Future<void> fetchOrders() async {
    if (_userId == null) return;
    try {
      final snapshot = await _firestore.collection('users').doc(_userId).collection('orders').orderBy('createdAt', descending: true).get();
      _orders.clear();
      for (final d in snapshot.docs) {
        final data = d.data();
        final items = <CartItem>[];
        if (data['items'] is List) {
          for (final e in data['items']) {
            items.add(CartItem(
              id: e['id'] ?? '',
              title: e['title'] ?? '',
              quantity: (e['quantity'] ?? 1) as int,
              price: (e['price'] ?? 0).toDouble(),
            ));
          }
        }
        _orders.add(OrderItem(
          id: d.id,
          items: items,
          amount: (data['amount'] ?? 0).toDouble(),
          status: data['status'] ?? 'placed',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          shippingAddress: Map<String, dynamic>.from(data['shippingAddress'] ?? {}),
        ));
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to fetch orders: $e');
    }
  }

  Future<String?> createOrder({required Map<String, CartItem> cartItems, required double total, required Map<String, dynamic> shippingAddress, required String paymentId}) async {
    if (_userId == null) return null;
    try {
      final itemsList = cartItems.entries.map((e) => {
        'id': e.key,
        'title': e.value.title,
        'quantity': e.value.quantity,
        'price': e.value.price,
      }).toList();

      final docRef = await _firestore.collection('users').doc(_userId).collection('orders').add({
        'items': itemsList,
        'amount': total,
        'status': 'placed',
        'paymentId': paymentId,
        'createdAt': FieldValue.serverTimestamp(),
        'shippingAddress': shippingAddress,
      });

      // also add to a top-level orders collection for admins/aggregates
      await _firestore.collection('orders').doc(docRef.id).set({
        'userId': _userId,
        'items': itemsList,
        'amount': total,
        'status': 'placed',
        'paymentId': paymentId,
        'createdAt': FieldValue.serverTimestamp(),
        'shippingAddress': shippingAddress,
      });

      // Fetch newly created order data locally
      await fetchOrders();
      return docRef.id;
    } catch (e) {
      if (kDebugMode) print('Failed to create order: $e');
      return null;
    }
  }
}