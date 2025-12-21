import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Vista de Sales"));
  }
}
