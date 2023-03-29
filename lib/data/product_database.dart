
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'product.dart';

class ProductsDatabase {
  static final ProductsDatabase instance = ProductsDatabase._init();

  static Database? _database;
  ProductsDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('price_list_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);

  }

  Future _createDB(Database db, int version) async {
    //final integerType = 'INTEGER NOT NULL';
   // final boolType = 'BOOLEAN NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $dataTable (
    ${ProductFields.productName} $textType,
    ${ProductFields.unit} $textType,
    ${ProductFields.costPrice} $textType,
    ${ProductFields.salePrice} $textType,
    ${ProductFields.groupName} $textType,
    ${ProductFields.id} $textType
    )
    ''');


  }

  Future<Product> create(Product product,String tableName) async {
    final db = await instance.database;

    final id = await db.insert(tableName, product.toJson());
      print(id);

    return product;//.copy(id: id.toString());
  }

  Future<Product> readProduct(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      dataTable,
      columns: ProductFields.values,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }
  Future<List<Product>> readAllProduct() async {
    final db = await instance.database;
    final result = await db.query(dataTable);
      return result.map((json) => Product.fromJson(json)).toList() ;

  }
  Future<List> readAllGroupList() async {
    final db = await instance.database;
    final result = await db.query(dataTable);
    //in here you get the all group name add to list and by using 'toSet' we delete the repeated words.
      return result.map((json) =>json[ProductFields.groupName] as String).toList().toSet().toList();

  }



  Future<int> update(Product product) async {
    final db = await instance.database;
    return db.update(
      dataTable,
      product.toJson(),
      where: '${ProductFields.id} = ?',
      whereArgs: [Product().id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(
      dataTable,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close;
  }
}
