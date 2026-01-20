import 'package:flutter/material.dart';
import 'package:qadrastock/models/menu_offer.models.dart';
import 'package:qadrastock/screens/home_screen.dart';

import 'core/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<MenuOffer> _offers = [];

  void _addOffer(MenuOffer offer) {
    setState(() {
      _offers.add(offer);
    });
  }

  void _removeOffer(MenuOffer offer) {
    setState(() {
      _offers.remove(offer);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        offers: _offers,
        onAddOffer: _addOffer,
        onRemoveOffer: _removeOffer,
      ),
      theme: AppTheme.lightTheme,
    );
  }
}
