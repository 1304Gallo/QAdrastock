import 'package:flutter/material.dart';
import 'package:qadrastock/core/app_color.dart';
import 'package:qadrastock/models/menu_offer.models.dart';
import 'package:qadrastock/models/sale_item.models.dart';

import '../models/sale.models.dart';

class SalesScreen extends StatefulWidget {
  final List<MenuOffer> availableOffers;

  const SalesScreen({super.key, required this.availableOffers});

  @override
  State<SalesScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<SalesScreen> {
  final List<Sale> _salesList = [];

  void _addSale(Sale sale) {
    setState(() {
      _salesList.add(sale);
    });
  }

  void _removeSale(int index) {
    setState(() {
      _salesList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Ventas", style: TextStyle(color: AppColors.primary)),
        centerTitle: true,
      ),
      body: _salesList.isEmpty
          ? const Center(
              child: Text(
                "No existen Ventas actualmente",
                style: TextStyle(color: AppColors.primary),
              ),
            )
          : ListView.builder(
              itemCount: _salesList.length,
              itemBuilder: (context, index) {
                final sale = _salesList[index];
                return Card(
                  color: AppColors.backgroundComponent,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      "Venta #${sale.id}",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sale.items
                          .map(
                            (item) => Text(
                              "${item.quantity} x ${item.offer.name}",
                              style: const TextStyle(color: AppColors.primary),
                            ),
                          )
                          .toList(),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${sale.precioVenta.toStringAsFixed(2)}",
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
                            _showDeleteSaleDialog(context, index);
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
              onPressed: () => _showAddSaleSheet(),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showDeleteSaleDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar venta"),
        content: const Text("¿Está seguro que desea eliminar esta la venta?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              _removeSale(index);
              Navigator.pop(context);
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSaleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddSaleSheet(
        onAddSale: _addSale,
        availableOffers: widget.availableOffers,
      ),
    );
  }
}

class AddSaleSheet extends StatefulWidget {
  final Function(Sale) onAddSale;
  final List<MenuOffer> availableOffers;

  const AddSaleSheet({
    super.key,
    required this.onAddSale,
    required this.availableOffers,
  });

  @override
  State<AddSaleSheet> createState() => _AddSaleSheetState();
}

class _AddSaleSheetState extends State<AddSaleSheet> {
  final _quantityController = TextEditingController();
  MenuOffer? _selectedOffer;
  final List<SaleItem> _saleItems = [];
  MetodoPago _metodoSeleccionado = MetodoPago.efectivo;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _addOfferToSale() {
    if (_selectedOffer != null && _quantityController.text.isNotEmpty) {
      final quantity = int.tryParse(_quantityController.text);
      if (quantity != null && quantity > 0) {
        setState(() {
          _saleItems.add(SaleItem(offer: _selectedOffer!, quantity: quantity));
          _selectedOffer = null;
          _quantityController.clear();
        });
      }
    }
  }

  void _saveSale() {
    if (_saleItems.isNotEmpty) {
      final total = _saleItems.fold(
        0.0,
        (sum, item) => sum + (item.offer.price * item.quantity),
      );
      final totalItems = _saleItems.fold(0, (sum, item) => sum + item.quantity);

      final newSale = Sale(
        id: DateTime.now().millisecondsSinceEpoch,
        hora: DateTime.now(),
        precio: total,
        items: List.from(_saleItems),
        totalItems: totalItems,
        metodoPago: _metodoSeleccionado,
      );
      widget.onAddSale(newSale);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _saleItems.fold(
      0.0,
      (sum, item) => sum + (item.offer.price * item.quantity),
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
            const Center(
              child: Text(
                "Nueva Venta",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<MetodoPago>(
              initialValue: _metodoSeleccionado,
              decoration: const InputDecoration(labelText: "Método de pago"),
              items: MetodoPago.values
                  .map(
                    (metodo) => DropdownMenuItem(
                      value: metodo,
                      child: Text(metodo.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _metodoSeleccionado = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<MenuOffer>(
                    initialValue: _selectedOffer,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: "Oferta"),
                    items: widget.availableOffers
                        .map(
                          (o) => DropdownMenuItem(
                            value: o,
                            child: Text(
                              o.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (o) => setState(() => _selectedOffer = o),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Cantidad"),
                  ),
                ),
                Expanded(
                  flex: 1, // Give the IconButton a flex factor
                  child: IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: _addOfferToSale,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._saleItems.map(
              (item) => ListTile(
                title: Text(item.offer.name),
                subtitle: Text("Cantidad: ${item.quantity}"),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  onPressed: () => setState(() => _saleItems.remove(item)),
                ),
              ),
            ),

            Text(
              "Total: \$${total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveSale,
                child: const Text(
                  "Guardar Venta",
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
}
