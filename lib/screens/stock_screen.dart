import 'package:flutter/material.dart';
import 'package:qadrastock/core/app_color.dart';
import 'package:qadrastock/services/stock_service.dart';

import '../models/entrada_stock.models.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final StockService _stockService = StockService();
  late List<Producto> _productos;

  @override
  void initState() {
    super.initState();
    _productos = _stockService.productos;
  }

  void _agregarOActualizarProducto(String nombre, int cantidad, double precio) {
    setState(() {
      _stockService.agregarOActualizarProducto(nombre, cantidad, precio);
      _productos = _stockService.productos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Stock", style: TextStyle(color: AppColors.primary)),
          ],
        ),
      ),
      body: _productos.isEmpty
          ? const Center(
              child: Text(
                "No hay productos en stock",
                style: TextStyle(color: AppColors.primary),
              ),
            )
          : ListView.builder(
              itemCount: _productos.length,
              itemBuilder: (context, index) {
                final producto = _productos[index];
                return Card(
                  color: AppColors.backgroundComponent,
                  margin: const EdgeInsets.all(6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      producto.nombre,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    subtitle: Text(
                      "Entradas: ${producto.historial.length}",
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    trailing: Text(
                      "${producto.stockTotal} und.",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    onTap: () => _mostrarDetalle(producto),
                  ),
                );
              },
            ),
      floatingActionButton: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: FloatingActionButton(
              onPressed: () => _showCreateNewProductForm(),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- DIÁLOGOS Y VISTAS AUXILIARES ---

  void _showCreateNewProductForm() {
    final nombreController = TextEditingController();
    final cantidadController = TextEditingController();
    final precioController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el contenido suba con el teclado
      backgroundColor:
          Colors.transparent, // Para que se vean los bordes redondeados
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          // Evita que el teclado tape los campos
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
                  // margin: EdgeInsets.bottom(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: const Text(
                  "Entrada en Stock",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre del Producto",
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cantidadController,
                      decoration: const InputDecoration(labelText: "Cantidad"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: precioController,
                      decoration: const InputDecoration(
                        labelText: "Precio Costo",
                        prefixText: "\$ ",
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final int? cant = int.tryParse(cantidadController.text);
                    final double? precio = double.tryParse(
                      precioController.text.replaceFirst(',', '.'),
                    );

                    if (nombreController.text.isNotEmpty &&
                        cant != null &&
                        precio != null) {
                      _agregarOActualizarProducto(
                        nombreController.text,
                        cant,
                        precio,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDetalle(Producto producto) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Historial de ${producto.nombre}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: producto.historial.length,
              itemBuilder: (context, i) {
                final entrada = producto.historial[i];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text("+ ${entrada.cantidad} unidades"),
                  subtitle: Text(
                    "${entrada.fecha.hour}:${entrada.fecha.minute} - ${entrada.fecha.day}/${entrada.fecha.month}",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
