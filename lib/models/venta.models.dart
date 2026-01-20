import 'menu_offer.models.dart';

class Venta {
  final int id;
  final DateTime hora;
  final double precio;
  final List<MenuOffer> ofertas;

  const Venta({
    required this.id,
    required this.hora,
    required this.precio,
    required this.ofertas,
  });

  double get precioVenta {
    if (ofertas.isEmpty) {
      return 0.0;
    }
    final totalValue = ofertas.fold(0.0, (sum, item) => sum + (item.price));
    return totalValue;
  }
}
