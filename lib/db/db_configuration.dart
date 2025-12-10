import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBConfiguration {
  // Clase de configuración de la base de datos
  static final DBConfiguration intance =
      DBConfiguration._init(); // Intancia para inicializar la base de datos
  static Database?
  _database; // Variable privada para almacenar la base de datos

  DBConfiguration._init();

  // Getter para obtener la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app_database.db');
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // Abrir la base de datos, si no existe se crea
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crear la tabla products en la base de datos
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        name TEXT,
        price NUMERIC
      )
    ''');
  }
}
