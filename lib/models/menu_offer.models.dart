import 'package:qadrastock/models/entrada_stock.models.dart';

class ProductOffer {
  final Producto product;
  final int quantity;
  final double price;

  ProductOffer({
    required this.product,
    required this.quantity,
    required this.price,
  });
}

class MenuOffer {
  final String name;
  final List<ProductOffer> products;
  final double price;

  MenuOffer({required this.name, required this.products, required this.price});

  double get costoTotal {
    return products.fold(
      0.0,
      (sum, item) => sum + (item.product.precioPromedio * item.quantity),
    );
  }

  double get precioSugerido {
    return costoTotal * 1.3;
  }
}
