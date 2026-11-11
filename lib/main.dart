import 'package:flutter/material.dart';

import 'models/campus_item.dart';
import 'pages/detail_data.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const CampusGoApp());
}

class CampusGoApp extends StatelessWidget {
  const CampusGoApp({super.key});

  static const String homeRoute = '/';
  static const String detailRoute = '/detail';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusGo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087F78),
          primary: const Color(0xFF087F78),
          secondary: const Color(0xFFFFB547),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7F8),
          foregroundColor: Color(0xFF152C3B),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFFE8EEF0)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE8EEF0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE8EEF0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF087F78), width: 1.5),
          ),
        ),
      ),
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => const CampusGoHomePage(),
        detailRoute: (context) {
          final argument = ModalRoute.of(context)?.settings.arguments;
          if (argument is CampusItem) {
            return DetailData(item: argument);
          }
          return const MissingDetailDataPage();
        },
      },
    );
  }
}

class MissingDetailDataPage extends StatelessWidget {
  const MissingDetailDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail tidak tersedia')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 48),
              const SizedBox(height: 12),
              const Text('Data detail tidak ditemukan.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  CampusGoApp.homeRoute,
                  (route) => false,
                ),
                child: const Text('Kembali ke beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
