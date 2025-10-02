import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String email = '';
  String password = '';
  bool isLoading = false;

  Future<void> _handleAnonymous() async {
    setState(() => isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).signInAnonymously();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _signIn() async {
    setState(() => isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).signInWithEmail(email, password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign in failed')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text('Welcome to Boutique', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextField(decoration: const InputDecoration(labelText: 'Email'), onChanged: (v) => email = v),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(labelText: 'Password'), onChanged: (v) => password = v, obscureText: true),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (!isLoading)
              Column(
                children: [
                  ElevatedButton(onPressed: _signIn, child: const Text('Sign in')), 
                  const SizedBox(height: 8),
                  TextButton(onPressed: _handleAnonymous, child: const Text('Continue as guest')), 
                ],
              ),
            const Spacer(),
            Text('Tip: configure Firebase and add a products collection to see remote products.', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
