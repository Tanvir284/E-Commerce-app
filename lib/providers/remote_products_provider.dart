import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class RemoteProductsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _items = [];

  List<Product> get items => [..._items];

  Future<void> fetchAndSetProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      _items = snapshot.docs.map((d) {
        final data = d.data();
        return Product(
          id: d.id,
          title: data['title'] ?? 'Untitled',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? '',
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to fetch remote products: $e');
    }
  }
}
