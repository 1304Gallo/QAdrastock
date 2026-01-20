import 'package:qadrastock/models/sale_item.models.dart';

class Venta {
  final int id;
  final DateTime hora;
  final double precio;
  final List<SaleItem> items;
  final int totalItems;

  const Venta({
    required this.id,
    required this.totalItems,
    required this.hora,
    required this.precio,
    required this.items,
  });

  double get precioVenta {
    if (items.isEmpty) {
      return 0.0;
    }
    final totalValue =
        items.fold(0.0, (sum, item) => sum + (item.offer.price * item.quantity));
    return totalValue;
  }
}
