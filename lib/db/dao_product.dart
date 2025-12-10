import 'db_configuration.dart';
import '../models/product.dart';

class DAOProduct {
  final DBConfig = DBConfiguration
      .intance; // Instancia de la configuración de la base de datos

  Future<int> insertProduct(Product product) async {
    final db = await DBConfig.database;
    return await db.insert('products', product.toMap());
  }

  // Actualizar un producto existente
  Future<int> updateProduct(Product product) async {
    final db = await DBConfig.database; // Obtener la base de datos
    return await db.update(
      // Actualizar el producto en la tabla
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [
        product.id,
      ], // Usar el id del producto para la condición de actualización
    );
  }

  // Eliminar un producto por su id
  Future<int> deleteProduct(int id) async {
    // Método para eliminar un producto
    final db = await DBConfig.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    ); // Eliminar el producto con el id especificado
  }

  // Obtener todos los productos de la base de datos
  Future<List<Product>> getAllProducts() async {
    final db = await DBConfig.database;
    final result = await db.query('products'); // Consultar todos los productos

    return result.map((row) => Product.fromMap(row)).toList();
  }
}
