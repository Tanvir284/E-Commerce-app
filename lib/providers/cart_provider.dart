import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({required this.id, required this.title, required this.quantity, required this.price});

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'quantity': quantity,
        'price': price,
      };

  static CartItem fromMap(Map<String, dynamic> map) => CartItem(
        id: map['id'],
        title: map['title'],
        quantity: map['quantity'],
        price: (map['price'] as num).toDouble(),
      );
}

class CartProvider with ChangeNotifier {
  static const _prefsKey = 'cart_items_v1';
  final Map<String, CartItem> _items = {};

  CartProvider() {
    _load();
  }

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get total {
    double sum = 0.0;
    _items.forEach((key, item) {
      sum += item.price * item.quantity;
    });
    return sum;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          quantity: existing.quantity + 1,
          price: existing.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: DateTime.now().toIso8601String(),
          title: product.title,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
    _save();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    final current = _items[productId]!;
    if (current.quantity > 1) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          quantity: existing.quantity - 1,
          price: existing.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    _save();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    _save();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _items.map((k, v) => MapEntry(k, v.toMap()));
    await prefs.setString(_prefsKey, jsonEncode(map));
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      map.forEach((key, value) {
        _items[key] = CartItem.fromMap(Map<String, dynamic>.from(value));
      });
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to load cart: $e');
    }
  }
}
