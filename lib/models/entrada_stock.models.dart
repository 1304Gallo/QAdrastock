class EntradaStock {
  final DateTime fecha;
  final int cantidad;

  EntradaStock({required this.fecha, required this.cantidad});
}

class Producto {
  final String id;
  final String nombre;
  final List<EntradaStock> historial;

  Producto({required this.id, required this.nombre, required this.historial});

  int get stockTotal => historial.fold(0, (sum, item) => sum + item.cantidad);
}
