import 'package:qadrastock/models/entrada_stock.models.dart';

class ProductOffer {
  final Producto product;
  final int quantity;

  ProductOffer({required this.product, required this.quantity});
}

class MenuOffer {
  final String name;
  final List<ProductOffer> products;

  MenuOffer({required this.name, required this.products});

  double get costoTotal {
    return products.fold(
        0.0,
        (sum, item) =>
            sum + (item.product.precioPromedio * item.quantity));
  }

  double get precioSugerido {
    return costoTotal * 1.3;
  }
}
