import '../models/product.dart';
import '../db/dao_product.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key}); // Constructor del widget ProductList

  @override
  State<ProductList> createState() => _ProductListState(); // Crear el estado del widget ProductList
}

class _ProductListState extends State<ProductList> {
  final DAOProduct _daoProduct = DAOProduct(); // Instancia del DAO de productos
  List<Product> _products = []; // Lista de productos cargados
  List<Product> _filteredProducts = []; // Lista de productos filtrados

  @override
  void initState() {
    super.initState(); // Inicializar el estado
    _initProducts();
  }

  // Inicializar productos en la base de datos si no existen
  Future<void> _initProducts() async {
    final products = await _daoProduct.getAllProducts();
    if (products.isEmpty) {
      for (int index = 1; index <= 15; index++) {
        await _daoProduct.insertProduct(
          Product(
            name: 'Producto $index',
            price: index * 10.0,
          ), // Insertar 15 productos iniciales
        );
      }
    }
    _loadProducts();
  }

  // Cargar productos desde la base de datos
  Future<void> _loadProducts() async {
    final products = await _daoProduct.getAllProducts();
    setState(() {
      // Actualizar el estado con los productos cargados
      _products = products;
      _filteredProducts = products;
    });
  }

  // Filtrar productos por nombre
  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Agregar un nuevo producto
  Future<void> _addProduct() async {
    await _daoProduct.insertProduct(
      Product(
        name: 'Nuevo Producto',
        price: 59.9,
      ), // Insertar un nuevo producto
    );
    _loadProducts();
    // Mostrar un SnackBar confirmando la adición
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Producto añadido'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Eliminar un producto por su id
  Future<void> _deleteProduct(int id) async {
    await _daoProduct.deleteProduct(id);
    _loadProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Producto eliminado'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Actualizar un producto existente
  Future<void> _updateProduct(Product product) async {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(
      text: product.price
          .toString(), // Inicializar el controlador con el precio actual
    );
    // Mostrar un diálogo para actualizar el producto
    final result = await showDialog<Product>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Actualizar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedProduct = Product(
                id: product.id,
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? product.price,
              );
              Navigator.pop(context, updatedProduct);
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
    // Si se actualizó el producto, guardarlo en la base de datos
    if (result != null) {
      await _daoProduct.updateProduct(result);
      _loadProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto actualizado'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construir la interfaz de usuario
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Productos con SQLite')),
      body: Column(
        children: [
          // Columna que contiene el campo de texto y la lista de productos
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // Campo de texto para filtrar productos
              decoration: InputDecoration(
                labelText: 'Filtrar productos',
                border: OutlineInputBorder(),
              ),
              onChanged:
                  _filterProducts, // Llamar a la función de filtrado al cambiar el texto
            ),
          ),
          Expanded(
            child: ListView.builder(
              // Lista de productos filtrados
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  // Mostrar cada producto en un ListTile
                  title: Text(product.name),
                  subtitle: Text('Precio: \$${product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _updateProduct(product),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(product.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Botón para agregar un nuevo producto
        onPressed: _addProduct,
        child: Icon(Icons.add),
      ),
    );
  }
}
