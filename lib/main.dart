import 'package:flutter/material.dart';
import 'screen_list/product_list.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key}); // Constructor del widget MainApp

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lista Filtro',
      home: ProductList(),
    ); // Construir la aplicación principal
  }
}
