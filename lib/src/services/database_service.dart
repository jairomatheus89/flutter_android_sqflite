import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
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
    print("PRIMEIRO ESTAGio");
    String path = join(await getDatabasesPath(), _databaseName);
    print("second");
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
        },
        onUpgrade: (db, oldVersion, newVersion) {
          print("Atualizando banco de dados de versão $oldVersion para $newVersion");
        },
      );
      print("thirds");
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
      throw e;
    }
    
  }

  showCards() async {
    var db = await database;
    try{
      var cardinsert = await db.query(_table);

      cardinsert.forEach((i){
        print("Dia ${i['datecolumn']}");
      });

    } catch (e){
      print(e);
    }
  }


  droptable() async {
    String path = join(await getDatabasesPath(), _databaseName);
    deleteDatabase(path);
    return print(_databaseName);

  }

}

