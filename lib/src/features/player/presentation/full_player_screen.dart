import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Text(
          'Full Player Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
