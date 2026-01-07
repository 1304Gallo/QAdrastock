import 'package:qadrastock/models/entrada_stock.models.dart';

class StockService {
  // Singleton pattern
  static final StockService _instance = StockService._internal();
  factory StockService() {
    return _instance;
  }
  StockService._internal();

  final List<Producto> _productos = [];

  List<Producto> get productos => _productos;

  void agregarOActualizarProducto(String nombre, int cantidad, double precio) {
    final index = _productos.indexWhere(
      (p) => p.nombre.toLowerCase() == nombre.toLowerCase(),
    );
    final nuevaEntrada = EntradaStock(
      fecha: DateTime.now(),
      cantidad: cantidad,
      precio: precio,
    );

    if (index != -1) {
      _productos[index].historial.add(nuevaEntrada);
    } else {
      _productos.add(
        Producto(
          id: DateTime.now().toString(),
          nombre: nombre,
          historial: [nuevaEntrada],
        ),
      );
    }
  }
}
