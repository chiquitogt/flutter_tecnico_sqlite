import '../models/product.dart'; // Importamos el modelo Product

class ServicesMockApi {
  Future<List<Product>> fetchProducts() async {
    // Simulamos un delay de red y se devuelve una lista de productos mock de 15 productos
    await Future.delayed(
      Duration(seconds: 5),
    ); // Simulador delay de red de 5 segundos
    return List.generate(
      15, // Retorna un List donde empezamos a generar los 15 productos
      (index) => Product(
        id:
            index +
            1, // El indice se usa para el id del producto empezando en 1
        name:
            'Product ${index + 1}', // El indice se usa para el id y nombre del producto
        price: (index + 1) * 15.0, // El precio se calcula en base al indice
      ),
    );
  }
}
// Como ya no necesitaremos esta clase para simular una API, podemos eliminar el archivo services_mock_api.dart