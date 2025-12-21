import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qadrastock/core/app_color.dart';
import 'package:qadrastock/screens/Home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, color: AppColors.backgroundComponent),
      Icon(Icons.sell, color: AppColors.backgroundComponent),
      Icon(Icons.widgets, color: AppColors.backgroundComponent),
      Icon(Icons.list, color: AppColors.backgroundComponent),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          title: Center(
            child: Text(
              'QadraStock',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        body: HomeScreen(),
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: AppColors.background,
          buttonBackgroundColor: AppColors.secondary,
          animationCurve: Curves.easeInOutExpo,
          items: items,
        ),
      ),
    );
  }
}
