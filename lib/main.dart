import 'package:flutter/material.dart';
import 'kartu_mahasiswa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFE8F1F8),
        body: Center(
          child: KartuMahasiswa(
            nama: 'Muhammad Panji Abdillah Rayagung',
            nim: '20250801181',
            programStudi: 'Teknik Informatika',
          ),
        ),
      ),
    );
  }
}