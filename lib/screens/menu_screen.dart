import 'package:flutter/material.dart';
import 'package:qadrastock/core/app_color.dart';
import 'package:qadrastock/models/entrada_stock.models.dart';
import 'package:qadrastock/models/menu_offer.models.dart';
import 'package:qadrastock/services/stock_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final StockService _stockService = StockService();
  List<MenuOffer> _offers = [];

  void _addOffer(MenuOffer offer) {
    setState(() {
      _offers.add(offer);
    });
  }

  void _removeOffer(int index) {
    setState(() {
      _offers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          "Menú",
          style: TextStyle(color: AppColors.primary),
        ),
      ),
      body: _offers.isEmpty
          ? const Center(
              child: Text(
                "No hay ofertas en el menú",
                style: TextStyle(color: AppColors.primary),
              ),
            )
          : ListView.builder(
              itemCount: _offers.length,
              itemBuilder: (context, index) {
                final offer = _offers[index];
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
                              "${p.quantity} x ${p.product.nombre}",
                              style: const TextStyle(color: AppColors.primary),
                            ),
                          )
                          .toList(),
                    ),
                    trailing: Text(
                      "\$${offer.precioSugerido.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Eliminar oferta"),
                          content: Text(
                              "¿Está seguro que desea eliminar la oferta ${offer.name}?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                _removeOffer(index);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Eliminar",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOfferDialog(),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddOfferDialog() {
    showDialog(
      context: context,
      builder: (context) => AddOfferDialog(
        stockProducts: _stockService.productos,
        onAddOffer: _addOffer,
      ),
    );
  }
}

class AddOfferDialog extends StatefulWidget {
  final List<Producto> stockProducts;
  final Function(MenuOffer) onAddOffer;

  const AddOfferDialog(
      {super.key, required this.stockProducts, required this.onAddOffer});

  @override
  State<AddOfferDialog> createState() => _AddOfferDialogState();
}

class _AddOfferDialogState extends State<AddOfferDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  Producto? _selectedProduct;
  final List<ProductOffer> _offerProducts = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva Oferta"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nombre de la oferta"),
            ),
            const SizedBox(height: 20),
            const Text("Productos"),
            ..._offerProducts.map(
              (p) => ListTile(
                title: Text(p.product.nombre),
                trailing: Text("x${p.quantity}"),
                onLongPress: () {
                  setState(() {
                    _offerProducts.remove(p);
                  });
                },
              ),
            ),
            const Divider(),
            DropdownButton<Producto>(
              value: _selectedProduct,
              hint: const Text("Seleccione un producto"),
              items: widget.stockProducts
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(p.nombre),
                    ),
                  )
                  .toList(),
              onChanged: (p) {
                setState(() {
                  _selectedProduct = p;
                });
              },
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: "Cantidad"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedProduct != null &&
                    _quantityController.text.isNotEmpty) {
                  setState(() {
                    _offerProducts.add(
                      ProductOffer(
                        product: _selectedProduct!,
                        quantity: int.parse(_quantityController.text),
                      ),
                    );
                    _selectedProduct = null;
                    _quantityController.clear();
                  });
                }
              },
              child: const Text("Agregar Producto"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty && _offerProducts.isNotEmpty) {
              final newOffer = MenuOffer(
                name: _nameController.text,
                products: _offerProducts,
              );
              widget.onAddOffer(newOffer);
              Navigator.pop(context);
            }
          },
          child: const Text("Guardar Oferta"),
        ),
      ],
    );
  }
}
