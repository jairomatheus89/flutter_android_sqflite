import 'package:flutter/gestures.dart';

import '../widgets/background_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';
import '../services/database_service.dart';

class Page2Page extends StatefulWidget {
  const Page2Page({super.key});

  @override
  State<Page2Page> createState() => Page2PageState();
}

class Page2PageState extends State<Page2Page> {
  @override
  Widget build(BuildContext context) {

    Page2Controller.instance.readingCards();
    Page2Controller.instance.readingTasks();

    return Scaffold(
      appBar: AppBarWidget(),
      drawer: DrawerPage2(),
      body: Stack(
        children: [
          BackgroundWidget(),
          Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(40, 0, 0, 0),
                    spreadRadius: 2,
                    blurRadius: 6
                  )
                ],
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(80, 244, 67, 54),
                    const Color.fromARGB(80, 76, 175, 79),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              width: 300,
              height: 460,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CardsListContainer(),
                ),
              )
            ),
          ),
        ],
      )
    );
  }
}


class DrawerPage2 extends StatefulWidget {
  const DrawerPage2({super.key});

  @override
  State<DrawerPage2> createState() {
    return _DrawerPage2State();
  }
}

class _DrawerPage2State extends State<DrawerPage2> {
  @override
  Widget build(BuildContext context) {

    int idCard = Page2Controller.instance.idCardson;

    List<Map<String,dynamic>> cardList = Page2Controller.instance.listofCards;

    var cardzin = cardList.where((e) => e['_id'] == idCard).first;

    return Drawer(
      child: Container(
        color: Colors.pink,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text(
                "TASKS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40
                ),
              ),
              Text(
                "Card: ${cardzin['datecolumn']}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10)
                ),
                width: 234,
                height: 321,
                child: DrawerListBuilder(),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Voltar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerListBuilder extends StatefulWidget {
  const DrawerListBuilder({super.key});

  @override
  State<DrawerListBuilder> createState() => _DrawerListBuilderState();
}

class _DrawerListBuilderState extends State<DrawerListBuilder> {
  @override
  Widget build(BuildContext context) {
    int idCard = Page2Controller.instance.idCardson;
    List<Map<String,dynamic>> cardList = Page2Controller.instance.listofCards;
    var cardzin = cardList.where((e) => e['_id'] == idCard).first;

    final taskList = Page2Controller.instance.listofTasks;

    final relation = taskList
      .where((e) => e['card_id'] == cardzin['_id'])
      .toList();

    return ListView.builder(
      itemCount: relation.length,
      itemBuilder: (context, index) {
        final item = relation[index];
        return ListTile(
          title: Text("${item['description']}"),
        );
      },
    );
  }
}

class CardsListContainer extends StatefulWidget {
  const CardsListContainer({super.key});

  @override
  State<CardsListContainer> createState() => _CardsListContainerState();
}

class _CardsListContainerState extends State<CardsListContainer> {

  bool existingCards = Page2Controller.instance.checkson;

  final db = DataBaseService();

  final TextStyle textStyle = TextStyle(
    fontSize: 100,
    fontWeight: FontWeight.normal,
  );

  LinearGradient mygradson = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      const Color.fromARGB(255, 0, 163, 22),
      Colors.white
    ]
  );

  final sexolandia = DataBaseService();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    if (!existingCards){
      return Text("Procurando cards\n(Não há cards criados)", textAlign: TextAlign.center,);
    }

    return Column(
      children: [
        Text(
          "Lista de Cards",
          style: TextStyle(
            fontSize: 28,
            color: Colors.green,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 1.0,
                offset: Offset(1, 1)
              )
            ]
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(100, 76, 175, 79),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(100, 0, 0, 0),
                  blurRadius: 6.0,
                  spreadRadius: 1.0,
                  offset: Offset(0, 0)
                )
              ],
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // color: const Color.fromARGB(193, 233, 30, 98),
                width: 250,
                child: ListViewWidget()
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class ListViewWidget extends StatefulWidget {
  const ListViewWidget({super.key});

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {

  var db = DataBaseService();

  List<Map<String, dynamic>> item = Page2Controller.instance.listofCards;

  void initState(){
    super.initState();
    loadingTasksList();
  }

  void loadingTasksList() async {
    final result = await db.showCards();
    setState(() {
      item = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: Page2Controller.instance.listofCards.length,
      itemBuilder:(context, index) {

        final itemIndex = item[index];
        final taskItems = Page2Controller.instance.listofTasks;

        final relation = taskItems
          .where((e) => e['card_id'] == itemIndex['_id'])
          .toList();

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: const Color.fromARGB(100, 244, 67, 54),
            border: Border.all(
              color: Colors.white,
              width: 3
            )
          ),
          padding: EdgeInsets.only(left: 10),
          margin: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0),
          child: ListTile(
            title: Text(
              "${itemIndex['datecolumn']}",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1)
                  )
                ]
              ),
            ),
            subtitle: item.isNotEmpty
              ? Text(
                "${relation.toList().length} tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
              )
              : Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  //color: const Color.fromARGB(255, 7, 204, 0),
                  constraints: BoxConstraints(maxWidth: 16),
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeAlign: 0.1,
                    strokeWidth: 3,
                  ),
                ),
              )
            ,
            onTap:() {
              int idCard = itemIndex['_id'];
              Page2Controller.instance.idCardson = idCard;
              Scaffold.of(context).openDrawer();
            },
          ),
        );
      },
    );
  }
}


class Page2Controller extends ChangeNotifier{

  //Estrutura singleton
  static final Page2Controller instance = Page2Controller._();
  Page2Controller._();
  //Estrutura singleton//

  var db = DataBaseService();
  bool checkson = false;
  List<Map<String, dynamic>> listofCards = [];
  List<Map<String, dynamic>> listofTasks = [];
  int idCardson = 0;

  void updateIdCard(){
    notifyListeners();
  }

  Future<bool> checkinExistCards() async {
    try {
      checkson = await db.existJustOneCard();
    } catch (e){
      throw ArgumentError("NEM TEM CARDS MEU FI!");
    }
    return checkson;
  }

  void readingCards() async{
    listofCards = await db.showCards();
    if(listofCards.isNotEmpty){
      checkson = true;
      notifyListeners();
    }
  }

  void readingTasks() async {
    listofTasks = await db.showTasks();
    if(listofTasks.isEmpty){
      print("TA FODINHA MEMO VIU!...");
    }
    notifyListeners();
  }

  void updateListeners() async {
    checkson = await checkinExistCards();
    if (checkson){
      print("ta vindo o checkson do comecin do app");
      readingCards();
    }
    print("checkson: $checkson");
    notifyListeners();
  }
}