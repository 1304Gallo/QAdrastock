import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qadrastock/screens/menu_screen.dart';
import 'package:qadrastock/screens/sales_screen.dart';
import 'package:qadrastock/screens/stock_screen.dart';

import '../core/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final items = <Widget>[
    Icon(Icons.home, color: AppColors.backgroundComponent),
    Icon(Icons.sell, color: AppColors.backgroundComponent),
    Icon(Icons.widgets, color: AppColors.backgroundComponent),
    Icon(Icons.list, color: AppColors.backgroundComponent),
  ];

  final List<Widget> _pages = [
    const Center(child: Text("Vista Inicio")),
    const SalesScreen(),
    const StockScreen(),
    const MenuScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Center(
          child: Text('QadraStock', style: TextStyle(color: AppColors.primary)),
        ),
      ),
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: AppColors.background,
        buttonBackgroundColor: AppColors.secondary,
        animationCurve: Curves.easeInOutExpo,
        items: items,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
