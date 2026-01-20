import 'package:flutter/material.dart';
import 'package:qadrastock/core/app_color.dart';
import 'package:qadrastock/models/menu_offer.models.dart';

import '../models/venta.models.dart';

class SalesScreen extends StatefulWidget {
  final List<MenuOffer> availableOffers;

  const SalesScreen({super.key, required this.availableOffers});

  @override
  State<SalesScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<SalesScreen> {
  final List<Venta> _salesList = [];

  void _addSale(Venta sale) {
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
                      children: sale.ofertas
                          .map(
                            (o) => Text(
                              o.name,
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
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Eliminar venta"),
                                content: const Text(
                                  "¿Está seguro que desea eliminar esta la venta?",
                                ),
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
              onPressed: () => _showAddSaleSheet(),
              child: const Icon(Icons.add, color: Colors.white),
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
      builder: (context) =>
          AddSaleSheet(onAddSale: _addSale, availableOffers: widget.availableOffers),
    );
  }
}

class AddSaleSheet extends StatefulWidget {
  final Function(Venta) onAddSale;
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
  MenuOffer? _selectedOffer;
  final List<MenuOffer> _saleOffers = [];

  void _addOfferToSale() {
    if (_selectedOffer != null) {
      setState(() {
        _saleOffers.add(_selectedOffer!);
        _selectedOffer = null;
      });
    }
  }

  void _saveSale() {
    if (_saleOffers.isNotEmpty) {
      final newSale = Venta(
        id: DateTime.now().millisecondsSinceEpoch,
        hora: DateTime.now(),
        precio: _saleOffers.fold(0.0, (sum, item) => sum + item.price),
        ofertas: List.from(_saleOffers),
      );
      widget.onAddSale(newSale);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _saleOffers.fold(0.0, (sum, item) => sum + item.price);

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
            const Center(
              child: Text(
                "Nueva Venta",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: DropdownButtonFormField<MenuOffer>(
                    initialValue: _selectedOffer,
                    decoration: const InputDecoration(labelText: "Oferta"),
                    items: widget.availableOffers
                        .map(
                          (o) =>
                              DropdownMenuItem(value: o, child: Text(o.name)),
                        )
                        .toList(),
                    onChanged: (o) => setState(() => _selectedOffer = o),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _addOfferToSale,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._saleOffers.map(
              (o) => ListTile(
                title: Text(o.name),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  onPressed: () => setState(() => _saleOffers.remove(o)),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
