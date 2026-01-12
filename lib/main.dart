import 'package:flutter/material.dart';
import 'package:qadrastock/screens/home_screen.dart';
import 'package:qadrastock/screens/menu_screen.dart';
import 'package:qadrastock/screens/sales_screen.dart';
import 'package:qadrastock/screens/stock_screen.dart';

import 'core/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: AppTheme.lightTheme,
      routes: {
        '/home': (context) => HomeScreen(),
        '/sales': (context) => SalesScreen(),
        '/menu': (context) => MenuScreen(),
        '/stock': (context) => StockScreen(),
      },
    );
  }
}
