import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Formzin()
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: Text.rich(
        TextSpan(
          style: TextStyle(fontSize: 50),
          children:[
            TextSpan(
              text: "AG",
              style: TextStyle(color: Colors.red)
            ),
            TextSpan(
              text: "Tech",
              style: TextStyle(color: Colors.white)
            )
          ]
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class Formzin extends StatelessWidget {
  GlobalKey<_DbListColumnState> _key = GlobalKey<_DbListColumnState>();

  String nameInput = '';

  Formzin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Container(
        alignment: Alignment.center,
        color: Colors.amber,
        child: Container(
          color: Colors.white,
          width: 250,
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                onChanged: (e){
                  nameInput = e;
                },
              ),
              TextButton(
                onPressed: () {
                  if(nameInput == '' || nameInput.length <= 3){
                    nameInput = '';
                    print("DIGITE ALGUM NOME com mais de 3 letras...");
                    return;
                  }

                  DataBaseService inserir = new DataBaseService();
                  inserir._insertNameData(nameInput);

                  _key.currentState?.reloadNames();
                },
                child: Text("inserir nome!")
              ),
              DbListColumn(key: _key)
            ],
          ),
        ),
      ),
    );
  }
}


class DbListColumn extends StatefulWidget {

  const DbListColumn({super.key});

  @override
  State<DbListColumn> createState() => _DbListColumnState();
}

class _DbListColumnState extends State<DbListColumn> {

  List<Widget> namesWidgets = [];
  bool isLoading = true;

  Future<void> loadingNames() async {
    final db = DataBaseService();
    final tablelist = await db._showNameRows();

    List list = tablelist;
    final listlentgh = list.length;

    for(var i = 0; i < listlentgh; i++){
      namesWidgets.add(Text(list[i]['name']));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadingNames();
  }

  void reloadNames(){
    setState(() {
      isLoading = true;
    });

    loadingNames();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      width: 200,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2.0)
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(6.0),
        child: ListView(
          children: namesWidgets,
        ),
      ),
    );
  }
}





class DataBaseService {
  static final _database_name = 'my_db';
  static final _database_version = 1;

  static final _table = 'peoples';
  static final _id_Column = '_id';
  static final _name_column = 'name';

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDataBase();

  _initDataBase() async {
    String path = join(await getDatabasesPath(), _database_name);
    return await openDatabase(
      path,
      version: _database_version,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_table (
            $_id_Column INTEGER PRIMARY KEY,
            $_name_column TEXT NOT NULL
          )
        ''');
      }
    );
  }

  _insertNameData(data) async {
    final db = await database;

    await db.insert(
      _table,{
        _name_column: data
      }
    );

    print("nome '$data' inserido na lista!");
  }

  _showNameRows() async {
    final db = await database;
    final res = await db.query(_table);
    return res;
  }

}

