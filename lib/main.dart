import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/products_provider.dart';
import 'providers/remote_products_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/wishlist_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RemoteProductsProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) {
            cart!..setUserId(auth.user?.uid);
            return cart;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, WishlistProvider>(
          create: (_) => WishlistProvider(),
          update: (_, auth, wishlist) {
            wishlist!..setUserId(auth.user?.uid);
            return wishlist;
          },
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Modern E-Commerce',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            textTheme: GoogleFonts.poppinsTextTheme(),
            useMaterial3: true,
          ),
          home: auth.isAuthenticated ? const HomeScreen() : const AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (c) => const ProductDetailScreen(),
            CartScreen.routeName: (c) => const CartScreen(),
            CheckoutScreen.routeName: (c) => const CheckoutScreen(),
            WishlistScreen.routeName: (c) => const WishlistScreen(),
          },
        ),
      ),
    );
  }
}
