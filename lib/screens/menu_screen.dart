import 'package:flutter/material.dart';
import 'package:qadrastock/core/app_color.dart';
import 'package:qadrastock/models/entrada_stock.models.dart';
import 'package:qadrastock/models/menu_offer.models.dart';
import 'package:qadrastock/services/stock_service.dart';

class MenuScreen extends StatefulWidget {
  final List<MenuOffer> offers;
  final Function(MenuOffer) onAddOffer;
  final Function(MenuOffer) onRemoveOffer;

  const MenuScreen({
    super.key,
    required this.offers,
    required this.onAddOffer,
    required this.onRemoveOffer,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final StockService _stockService = StockService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Menú",
              style: TextStyle(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: widget.offers.isEmpty
          ? const Center(
              child: Text(
                "No hay ofertas en el menú",
                style: TextStyle(color: AppColors.primary),
              ),
            )
          : ListView.builder(
              itemCount: widget.offers.length,
              itemBuilder: (context, index) {
                final offer = widget.offers[index];
                return Card(
                  color: AppColors.backgroundComponent,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      offer.name,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: offer.products
                          .map(
                            (p) => Text(
                              "${p.quantity}  ${p.product.nombre}",
                              style: const TextStyle(color: AppColors.primary),
                            ),
                          )
                          .toList(),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${offer.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.accent,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Eliminar oferta"),
                                content: const Text(
                                  "¿Está seguro que desea eliminar esta la oferta?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      widget.onRemoveOffer(offer);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Eliminar",
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: FloatingActionButton(
              onPressed: () => _showAddOfferSheet(),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddOfferSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que suba con el teclado
      backgroundColor: Colors.transparent, // Para bordes redondeados
      builder: (context) => AddOfferSheet(
        stockProducts: _stockService.productos,
        onAddOffer: widget.onAddOffer,
      ),
    );
  }
}

// --- NUEVO DISEÑO DEL FORMULARIO ---

class AddOfferSheet extends StatefulWidget {
  final List<Producto> stockProducts;
  final Function(MenuOffer) onAddOffer;

  const AddOfferSheet({
    super.key,
    required this.stockProducts,
    required this.onAddOffer,
  });

  @override
  State<AddOfferSheet> createState() => _AddOfferSheetState();
}

class _AddOfferSheetState extends State<AddOfferSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  Producto? _selectedProduct;
  final List<ProductOffer> _offerProducts = [];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ofertaTemporal = MenuOffer(
      name: _nameController.text,
      products: _offerProducts,
      price: 0.0,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: const Text(
                "Oferta",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nombre de la oferta",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Selector de productos
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                // Cambiamos Column por Row
                crossAxisAlignment: CrossAxisAlignment
                    .end, // Alinea el botón con la base de los inputs
                children: [
                  // 1. EL SELECT (DROPDOWN)
                  Expanded(
                    flex: 3, // Ocupa 3 partes del espacio
                    child: DropdownButtonFormField<Producto>(
                      borderRadius: BorderRadius.circular(16),
                      initialValue: _selectedProduct,
                      decoration: const InputDecoration(
                        labelText: "Producto",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      items: widget.stockProducts
                          .map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (p) => setState(() => _selectedProduct = p),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 2. LA CANTIDAD
                  Expanded(
                    flex:
                        2, // Ocupa 2 partes del espacio (más pequeño que el select)
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Cant."),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 3. EL BOTÓN
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _addProductToOffer,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                        ), // Usamos solo icono para ahorrar espacio en la fila
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Lista de productos ya agregados
            ..._offerProducts.map(
              (p) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(p.product.nombre),
                subtitle: Text("Cantidad: ${p.quantity}"),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  onPressed: () => setState(() => _offerProducts.remove(p)),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Campo de Precio con tu lógica de precio sugerido
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Precio de Venta',
                hint: Text(
                  'Sugerido: \$${ofertaTemporal.precioSugerido.toStringAsFixed(2)}',
                ),
                prefixText: '\$ ',
                filled: true,
                fillColor: AppColors.primary.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveOffer,
                child: const Text(
                  "Guardar Oferta",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addProductToOffer() {
    final int? cant = int.tryParse(_quantityController.text);
    if (_selectedProduct != null && cant != null && cant > 0) {
      setState(() {
        _offerProducts.add(
          ProductOffer(product: _selectedProduct!, quantity: cant, price: 0.0),
        );
        _selectedProduct = null;
        _quantityController.clear();
      });
    }
  }

  void _saveOffer() {
    final double? precio = double.tryParse(
      _priceController.text.replaceFirst(',', '.'),
    );
    if (_nameController.text.isNotEmpty &&
        _offerProducts.isNotEmpty &&
        precio != null) {
      widget.onAddOffer(
        MenuOffer(
          name: _nameController.text,
          products: List.from(_offerProducts),
          price: precio,
        ),
      );
      Navigator.pop(context);
    }
  }
}
