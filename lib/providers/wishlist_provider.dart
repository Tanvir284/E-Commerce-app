import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  static const _prefsKey = 'wishlist_items';
  final Map<String, Product> _items = {};

  WishlistProvider() {
    _load();
  }

  List<Product> get items => _items.values.toList();
  bool isInWishlist(String productId) => _items.containsKey(productId);

  void add(Product product) {
    _items[product.id] = product;
    notifyListeners();
    _save();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _items.values.map((p) => {
      'id': p.id,
      'title': p.title,
      'description': p.description,
      'price': p.price,
      'imageUrl': p.imageUrl,
      'category': p.category,
    }).toList();
    await prefs.setString(_prefsKey, jsonEncode(list));
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        final p = Product(
          id: map['id'],
          title: map['title'],
          description: map['description'],
          price: (map['price'] as num).toDouble(),
          imageUrl: map['imageUrl'],
          category: map['category'],
        );
        _items[p.id] = p;
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to load wishlist: $e');
    }
  }
}
