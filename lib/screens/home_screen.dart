import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qadrastock/models/menu_offer.models.dart';
import 'package:qadrastock/screens/menu_screen.dart';
import 'package:qadrastock/screens/sales_screen.dart';
import 'package:qadrastock/screens/stock_screen.dart';

import '../core/app_color.dart';

class HomeScreen extends StatefulWidget {
  final List<MenuOffer> offers;
  final Function(MenuOffer) onAddOffer;
  final Function(MenuOffer) onRemoveOffer;

  const HomeScreen({
    super.key,
    required this.offers,
    required this.onAddOffer,
    required this.onRemoveOffer,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const Center(child: Text("Vista Inicio")),
      SalesScreen(availableOffers: widget.offers),
      const StockScreen(),
      MenuScreen(
        offers: widget.offers,
        onAddOffer: widget.onAddOffer,
        onRemoveOffer: widget.onRemoveOffer,
      ),
    ];
    final items = <Widget>[
      Icon(
        Icons.home,
        color: _currentIndex == 0
            ? AppColors.primary
            : AppColors.backgroundComponent,
      ),
      Icon(
        Icons.sell,
        color: _currentIndex == 1
            ? AppColors.primary
            : AppColors.backgroundComponent,
      ),
      Icon(
        Icons.widgets,
        color: _currentIndex == 2
            ? AppColors.primary
            : AppColors.backgroundComponent,
      ),
      Icon(
        Icons.list,
        color: _currentIndex == 3
            ? AppColors.primary
            : AppColors.backgroundComponent,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Center(
          child: Text('QadraStock', style: TextStyle(color: AppColors.primary)),
        ),
      ),
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: pages),
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
