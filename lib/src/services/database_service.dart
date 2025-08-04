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
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await db.execute('PRAGMA foreign_keys = ON');

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

  updateTaskForDone(taskId) async {
    var db = await database;

    try{
      await db.rawUpdate(
        'UPDATE task_card SET id_done = CASE id_done WHEN 1 THEN 0 ELSE 1 END WHERE _id = ?',
        [taskId]
      );
    } catch (e){
      throw Exception(e);
    }
  }


  showCards() async {
    var db = await database;
    try{
      final List<Map<String, dynamic>> cardinsert = await db.query(
        _table,
        orderBy: 'scheduledAt ASC'
      );
      cardinsert.forEach((i){
        print(i);
      });
      return cardinsert;
    } catch (e){
      throw Exception(e);
    }
  }

  showTasks() async {
    var db = await database;

    try {
      final List<Map<String, dynamic>> tasksHandle = await db.query('task_card');

      if(tasksHandle.isEmpty){
        throw Exception("TA VAZIO SAPOHA DE TASKS LISTS");
      }

      tasksHandle.forEach((i){
        print(i);
      });
      return tasksHandle;
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

  Future<bool> existJustOneCard() async {
    var db = await database;
    final result = await db.query(_table);
    return result.isNotEmpty;
  }

  deleteCardFromId(cardId) async {
    var db = await database;

    try{
      db.execute('''
        DELETE FROM $_table WHERE $_idCardColumn = $cardId;
      ''');
      print("card deletado!");
    } catch (e){
      throw Exception(e);
    }
    
  }

  droptable() async {
    try{
      await deleteDatabase(join(await getDatabasesPath(), _databaseName));
      return print("db Deleted!");
    } catch (e){
      rethrow;
    }
  }
}