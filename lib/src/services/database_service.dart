import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  static final _databaseName = 'my_db';
  static final _databaseVersion = 1;

  static final _table = 'card_id';
  static final _idCardColumn = '_id';
  static final _dateCardColumn = 'datecolumn';

  static Database? _database;
  Future<Database> get database async => _database ??= await initDataBase();

  initDataBase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    try {

      Database db = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: (db, version) {

          db.execute('''
            CREATE TABLE IF NOT EXISTS $_table (
              $_idCardColumn INTEGER PRIMARY KEY,
              $_dateCardColumn TEXT NOT NULL UNIQUE
            )
          ''');

          db.execute('''
            CREATE TABLE IF NOT EXISTS task_card (
              _id INTEGER PRIMARY KEY,
              card_id INTEGER NOT NULL,
              description TEXT NOT NULL,
              id_done INTEGER NOT NULL DEFAULT 0,
              FOREIGN KEY (card_id) REFERENCES card_day(_id) ON DELETE CASCADE
            )
          ''');

          print("Tabelas de cards e tasks criadas!");
        },
        onUpgrade: (db, oldVersion, newVersion) {
          print("Atualizando banco de dados de versão $oldVersion para $newVersion");
        },
      );
      print("Banco de dados iniciado e/ou recriado(se necessario)");

      return db;
    } catch (e){
      print(e);
      rethrow;
    }
  }

  insertCard(cardmodel) async {
    var db = await database;

    try{
      await db.insert(_table,
        cardmodel,
        conflictAlgorithm: ConflictAlgorithm.abort
      );
    } catch (e){
      rethrow;
    } 
  }

  insertTask(taskmodel) async {
    var db = await database;

    try {
      await db.insert('task_card',
        taskmodel,
        conflictAlgorithm: ConflictAlgorithm.abort
      );
      print("FOI TITIU!");
    } catch (e){
      rethrow;
    }
  }

  showCards() async {

    var db = await database;

    try{
      var cardinsert = await db.query(_table);
      for (var i in cardinsert) {
        print(i);
      }
    } catch (e){
      print(e);
    }
  }

  showTasks() async {

    var db = await database;

    try{
      var cardinsert = await db.query('task_card');
      for (var i in cardinsert) {
        print(i);
      }
    } catch (e){
      print(e);
    }
  }

  checkCardExist(cardDate) async {
    var db = await database;
    try{
      var zegotin = await db.query(_table,
      columns: [_idCardColumn],
      where: '$_dateCardColumn = ?',
      whereArgs: [cardDate]
    );
    print(zegotin[0]);
    } catch (e) {
      print("Ta Foda!: $e");
    }
    
  }

  deleteCardFromId(card_id) async {
    var db = await database;

    db.execute('''
      DELETE FROM $_table WHERE $_idCardColumn = $card_id;
    ''');
  }

  droptable() async {
    var db = await database;

    try{
      await deleteDatabase(join(await getDatabasesPath(), _databaseName));
      return print("Banco Deleted FDP!");
    } catch (e){
      rethrow;
    }
  }
}