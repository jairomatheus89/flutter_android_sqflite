import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  static final _databaseName = 'my_db';
  static final _databaseVersion = 1;

  static final _table = 'cardtable';
  static final _idColumn = '_id';
  static final _dateColumn = 'datecolumn';

  static Database? _database;
  Future<Database> get database async => _database ??= await initDataBase();

  initDataBase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        print("criando sapoha!...");
        db.execute('''
          CREATE TABLE IF NOT EXISTS $_table (
            $_idColumn INTEGER PRIMARY KEY,
            $_dateColumn TEXT NOT NULL UNIQUE
          )
        ''');
        print("Tabela $_table criada com sucesso!");
      },
      onUpgrade: (db, oldVersion, newVersion) {
        print("Atualizando banco de dados de versão $oldVersion para $newVersion");
      },
    );
  }

  insertCardData(data) async {
    final db = await database;

    try{
      await db.insert(
        _table,{
          _dateColumn: data
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return 'SALVO COM SUCESSO';
    } catch (e) {
      throw 'unique';
    }
  }

  Future<List<Map<String, dynamic>>> showNameRows() async {
    final db = await database;
    try {
      final res = await db.query(_table);
      return res;
    } catch (e) {
      // Caso ocorra algum erro (ex. tabela não encontrada), reinicializa a tabela  // Opcional, se quiser sempre resetar a tabela
      throw Exception("Tabelita none encontred: $e");   // Chama novamente para garantir que a tabela será criada
    }
  }

  deleteAllCards() async {
    final db = await database;
    try {
      await db.execute('DROP TABLE IF EXISTS $_table');

      await db.execute('''
          CREATE TABLE IF NOT EXISTS $_table (
            $_idColumn INTEGER PRIMARY KEY,
            $_dateColumn TEXT NOT NULL UNIQUE
          )
      ''');
      print("BANCO DELETADO!!!");
    } catch (e){
      throw Exception("Erro ao deletar a tabela: $e");
    }
  }

}

