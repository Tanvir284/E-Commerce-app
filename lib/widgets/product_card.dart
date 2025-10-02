import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final wishlist = Provider.of<WishlistProvider>(context);
    final inWishlist = wishlist.isInWishlist(product.id);

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: product.id,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => Container(color: Colors.grey[200]),
                      errorWidget: (ctx, url, err) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(product.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.deepPurple)),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(inWishlist ? Icons.favorite : Icons.favorite_border, color: inWishlist ? Colors.red : null),
                    onPressed: () {
                      if (inWishlist) {
                        wishlist.remove(product.id);
                      } else {
                        wishlist.add(product);
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cart.addItem(product);
                      final snack = SnackBar(content: Text('Added ${product.title} to cart'), duration: const Duration(seconds: 1));
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    },
                    child: const Text('Add'),
                    style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12)))), 
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
