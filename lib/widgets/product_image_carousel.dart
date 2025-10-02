import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductImageCarousel extends StatelessWidget {
  final List<String> images;
  const ProductImageCarousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images.map((url) {
        return Builder(builder: (context) {
          return CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (c, u) => Container(color: Colors.grey[200]),
            errorWidget: (c, u, e) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
          );
        });
      }).toList(),
      options: CarouselOptions(
        height: 320,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
      ),
    );
  }
}
