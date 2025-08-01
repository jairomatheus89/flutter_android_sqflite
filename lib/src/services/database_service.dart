import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/card_day.model.dart';

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
              $_dateCardColumn TEXT NOT NULL UNIQUE,
              scheduledAt INTEGER
            )
          ''');

          db.execute('''
            CREATE TABLE IF NOT EXISTS task_card (
              _id INTEGER PRIMARY KEY,
              card_id INTEGER NOT NULL,
              description TEXT NOT NULL,
              id_done INTEGER NOT NULL DEFAULT 0,
              FOREIGN KEY (card_id) REFERENCES $_table($_idCardColumn) ON DELETE CASCADE
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) {

        },
      );

      return db;
    } catch (e){
      rethrow;
    }
  }

  Future<void> insertCard(CardDayModel cardmodel) async {
    var db = await database;

    try{

      int cardId = await db.insert(_table,
        cardmodel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort
      );

      for(var tasks in cardmodel.tasks){
        await db.insert('task_card', {
            'description': tasks.description,
            'card_id': cardId
          },
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  showCards() async {
    
    var db = await database;
    
    try{
      var cardinsert = await db.query(_table);
      if (cardinsert.isEmpty){
        throw Exception("errinho aqui");
      }
      for (var i in cardinsert) {
        print(i);
      }
      return;
    } catch (e){
      throw Exception(e);
    }
  }

  showTasks() async {
    var db = await database;

    try {
      var tasksHandle = await db.query('task_card');

      if(tasksHandle.isEmpty){
        throw Exception("TA VAZIO SAPOHA DE TASKS LISTS");
      }

      tasksHandle.forEach((i){
        print(i);
      });
      return;
    } catch (e){
      throw Exception(e);
    }
  }


  Future<bool> checkCardExist(String cardDate) async {
    var db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      _table,
      where: '$_dateCardColumn = ?',
      whereArgs: [cardDate],
    );

    return result.isNotEmpty;
  }

  deleteCardFromId(cardId) async {
    var db = await database;

    db.execute('''
      DELETE FROM $_table WHERE $_idCardColumn = $cardId;
    ''');
  }

  droptable() async {
    try{
      await deleteDatabase(join(await getDatabasesPath(), _databaseName));
      return print("Banco Deleted FDP!");
    } catch (e){
      rethrow;
    }
  }
}