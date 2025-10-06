import 'package:flutter/material.dart';

class AtlasScreen extends StatelessWidget {
  const AtlasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atlas'),
      ),
      body: const Center(
        child: Text('Discovery Hub'),
      ),
    );
  }
}
