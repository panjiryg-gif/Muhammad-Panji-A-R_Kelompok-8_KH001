import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Tambahkan import ini

import 'theme/app_theme.dart';
import 'widgets/button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Helper method untuk membuka URL Google Maps
  Future<void> _openMaps() async {
    final Uri uri = Uri.parse(
      'https://github.com/nopallrsyahh',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link Ke Git hub si ganteng',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tekan tombol di bawah untuk melihat link github si ganteng.',
            ),
            const SizedBox(height: 24),

            // Tombol 1: Menggunakan onPressed untuk panggil _openMaps
            AppButton(
              label: 'Buka Link si ganteng',
              icon: Icons.location_on,
              onPressed: _openMaps,
            ),

            const SizedBox(height: 16),

            // Tombol 2: Menggunakan onPressed biasa
            AppButton(
              label: 'Tes Tombol',
              icon: Icons.touch_app,
              onPressed: () {
                debugPrint('Tombol berhasil ditekan!');
              },
            ),
          ],
        ),
      ),
    );
  }
}