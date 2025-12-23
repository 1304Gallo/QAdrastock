import 'package:flutter/material.dart';
import 'package:qadrastock/core/app_color.dart';

import '../models/entrada_stock.models.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Producto> productos = [];

  void _agregarOActualizarProducto(String nombre, int cantidad) {
    setState(() {
      final index = productos.indexWhere(
        (p) => p.nombre.toLowerCase() == nombre.toLowerCase(),
      );
      final nuevaEntrada = EntradaStock(
        fecha: DateTime.now(),
        cantidad: cantidad,
      );

      if (index != -1) {
        // El producto ya existe, añadimos al historial
        productos[index].historial.add(nuevaEntrada);
      } else {
        // Producto nuevo
        productos.add(
          Producto(
            id: DateTime.now().toString(),
            nombre: nombre,
            historial: [nuevaEntrada],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          "Control de Stock",
          style: TextStyle(color: AppColors.primary),
        ),
      ),
      body: productos.isEmpty
          ? const Center(
              child: Text(
                "No hay productos en stock",
                style: TextStyle(color: AppColors.primary),
              ),
            )
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  color: AppColors.backgroundComponent,
                  margin: EdgeInsetsGeometry.all(6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      producto.nombre,
                      style: TextStyle(color: AppColors.primary),
                    ),
                    subtitle: Text(
                      "Entradas: ${producto.historial.length}",
                      style: TextStyle(color: AppColors.primary),
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
              onPressed: () => _mostrarDialogoAgregar(),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- DIÁLOGOS Y VISTAS AUXILIARES ---

  void _mostrarDialogoAgregar() {
    final nombreController = TextEditingController();
    final cantidadController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nueva Entrada"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre del Producto",
              ),
            ),
            TextField(
              controller: cantidadController,
              decoration: const InputDecoration(labelText: "Cantidad"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreController.text.isNotEmpty &&
                  cantidadController.text.isNotEmpty) {
                _agregarOActualizarProducto(
                  nombreController.text,
                  int.parse(cantidadController.text),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
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
