import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  static final _database_name = 'my_db';
  static final _database_version = 1;

  static final _table = 'peoples';
  static final _id_Column = '_id';
  static final _name_column = 'name';

  static Database? _database;
  Future<Database> get database async => _database ??= await initDataBase();

  initDataBase() async {
    String path = join(await getDatabasesPath(), _database_name);
    return await openDatabase(
      path,
      version: _database_version,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS $_table (
            $_id_Column INTEGER PRIMARY KEY,
            $_name_column TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        print("Upgrade do banco de dados de $oldVersion para $newVersion");
      },
    );
  }

  insertNameData(data) async {
    final db = await database;

    await db.insert(
      _table,{
        _name_column: data
      }
    );

    print("nome '$data' inserido na lista!");
  }

  Future<List<Map<String, dynamic>>> showNameRows() async {
    final db = await database;
    try {
      final res = await db.query(_table);
      return res;
    } catch (e) {
      print("Erro ao acessar a tabela: $e");
      // Caso ocorra algum erro (ex. tabela não encontrada), reinicializa a tabela
      await deleteAllUsers();  // Opcional, se quiser sempre resetar a tabela
      return showNameRows();   // Chama novamente para garantir que a tabela será criada
    }
  }

  deleteAllUsers() async {
    final db = await database;
    try {
      await db.execute('DROP TABLE IF EXISTS $_table');
      print("tabela $_table deletada!");

      await db.execute('''
          CREATE TABLE IF NOT EXISTS $_table (
            $_id_Column INTEGER PRIMARY KEY,
            $_name_column TEXT NOT NULL
          )
      ''');
      print("tabela $_table recriada!");
    } catch (e){
      print("Erro ao deletar a tabela: $e");
    }
  }

}

