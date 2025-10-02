import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  static const _prefsKey = 'wishlist_items';
  final Map<String, Product> _items = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;

  WishlistProvider() {
    _load();
  }

  List<Product> get items => _items.values.toList();
  bool isInWishlist(String productId) => _items.containsKey(productId);

  void add(Product product) {
    _items[product.id] = product;
    notifyListeners();
    _save();
    if (_userId != null) _saveRemoteItem(product);
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
    _save();
    if (_userId != null) _removeRemoteItem(productId);
  }

  Future<void> setUserId(String? uid) async {
    _userId = uid;
    if (_userId != null) {
      // push local items to remote and then fetch remote to merge
      await _pushAllToRemote();
      await _fetchRemote();
    }
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

  Future<void> _saveRemoteItem(Product product) async {
    try {
      await _firestore.collection('users').doc(_userId).collection('wishlist').doc(product.id).set({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'category': product.category,
      });
    } catch (e) {
      if (kDebugMode) print('Failed to save wishlist item remotely: $e');
    }
  }

  Future<void> _removeRemoteItem(String productId) async {
    try {
      await _firestore.collection('users').doc(_userId).collection('wishlist').doc(productId).delete();
    } catch (e) {
      if (kDebugMode) print('Failed to remove remote wishlist item: $e');
    }
  }

  Future<void> _pushAllToRemote() async {
    try {
      final batch = _firestore.batch();
      final col = _firestore.collection('users').doc(_userId).collection('wishlist');
      for (final p in _items.values) {
        final ref = col.doc(p.id);
        batch.set(ref, {
          'title': p.title,
          'description': p.description,
          'price': p.price,
          'imageUrl': p.imageUrl,
          'category': p.category,
        });
      }
      await batch.commit();
    } catch (e) {
      if (kDebugMode) print('Failed to push wishlist to remote: $e');
    }
  }

  Future<void> _fetchRemote() async {
    try {
      final snapshot = await _firestore.collection('users').doc(_userId).collection('wishlist').get();
      // overwrite local with remote (simple strategy)
      _items.clear();
      for (final d in snapshot.docs) {
        final data = d.data();
        final p = Product(
          id: d.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? '',
        );
        _items[p.id] = p;
      }
      notifyListeners();
      await _save();
    } catch (e) {
      if (kDebugMode) print('Failed to fetch remote wishlist: $e');
    }
  }
}
