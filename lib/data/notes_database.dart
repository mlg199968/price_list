
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'data_price_store.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;
  NotesDatabase._init();
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
    ${NoteFields.productName} $textType,
    ${NoteFields.unit} $textType,
    ${NoteFields.costPrice} $textType,
    ${NoteFields.salePrice} $textType,
    ${NoteFields.groupName} $textType,
    ${NoteFields.id} $textType
    )
    ''');


  }

  Future<Note> create(Note note,String tableName) async {
    final db = await instance.database;

    final id = await db.insert(tableName, note.toJson());
      print(id);

    return note;//.copy(id: id.toString());
  }

  Future<Note> readNote(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      dataTable,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }
  Future<List> readAllNote() async {
    final db = await instance.database;
    final result = await db.query(dataTable);
      return result.map((json) => Note.fromJsonToList(json)).toList() ;

  }
  Future<List>
  readAllGroupList() async {
    final db = await instance.database;
    final result = await db.query(dataTable);
    //in here you get the all group name add to list and by using 'toSet' we delete the repeated words.
      return result.map((json) =>json[NoteFields.groupName] as String).toList().toSet().toList();

  }



  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      dataTable,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(
      dataTable,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close;
  }
}
