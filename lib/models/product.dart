class Product {
  final int? id; // Identificador del producto
  final String name; // Nombre del producto
  final double price; // Precio del producto

  Product({
    this.id, // Constructor opcional para id
    required this.name,
    required this.price,
  });

  // Convertir el objeto Product a un mapa para la base de datos
  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'price': price,
    }; // Mapa con los campos name y price
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  // Crear un objeto Product a partir de un mapa de la base de datos
  factory Product.fromMap(Map<String, dynamic> map) {
    // Factory constructor para crear un Product desde un mapa
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }
}
