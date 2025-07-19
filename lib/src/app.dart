import 'package:flutter/material.dart';
import './pages/formzin_page.dart';
import './pages/page2_page.dart';
import './pages/about_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes:{
        '/': (context) => const Formzin(),
        '/page2': (context) => const Page2Page(),
        '/aboutpage': (context) => const AboutPage()
      }
    );
  }
}