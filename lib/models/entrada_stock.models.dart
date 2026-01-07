class EntradaStock {
  final DateTime fecha;
  final int cantidad;
  final double precio;

  EntradaStock(
      {required this.fecha, required this.cantidad, required this.precio});
}

class Producto {
  final String id;
  final String nombre;
  final List<EntradaStock> historial;

  Producto({required this.id, required this.nombre, required this.historial});

  int get stockTotal => historial.fold(0, (sum, item) => sum + item.cantidad);

  double get precioPromedio {
    if (historial.isEmpty) {
      return 0.0;
    }
    final totalValue =
        historial.fold(0.0, (sum, item) => sum + (item.cantidad * item.precio));
    final totalQuantity =
        historial.fold(0, (sum, item) => sum + item.cantidad);
    return totalValue / totalQuantity;
  }
}
