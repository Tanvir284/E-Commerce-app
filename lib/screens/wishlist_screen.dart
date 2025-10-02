import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/wishlist';
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')), 
      body: wishlist.items.isEmpty
          ? const Center(child: Text('Your wishlist is empty'))
          : ListView.builder(
              itemCount: wishlist.items.length,
              itemBuilder: (ctx, i) {
                final p = wishlist.items[i];
                return ListTile(
                  leading: Image.network(p.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                  title: Text(p.title),
                  subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        onPressed: () {
                          cart.addItem(p);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${p.title} to cart')));
                        },
                        icon: const Icon(Icons.shopping_cart_outlined)),
                    IconButton(
                      onPressed: () => wishlist.remove(p.id),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ]),
                );
              },
            ),
    );
  }
}
