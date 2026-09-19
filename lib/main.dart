import 'package:flutter/material.dart';
import 'screens/projects_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion de projets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCC9900),
        ),
        useMaterial3: true,
      ),
      home: const ProjectsScreen(),
    );
  }
}
