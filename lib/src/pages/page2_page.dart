import 'package:flutter/gestures.dart';

import '../widgets/background_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';
import '../services/database_service.dart';

class Page2Page extends StatefulWidget {
  const Page2Page({super.key});

  @override
  State<Page2Page> createState() => _Page2PageState();
}

class _Page2PageState extends State<Page2Page> {

  @override
  Widget build(BuildContext context) {

    Page2Controller.instance.readingCards();
    Page2Controller.instance.readingTasks();

    return Scaffold(
      appBar: AppBarWidget(),
      drawer: Drawer(
        child: Container(
          color: Colors.pink,
          child: Center(
            child: TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(
                "VORTA PA TRAIS",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ),
        ),
      ),
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
        Container(
          alignment: Alignment.center,
          width: 220,
          margin: EdgeInsetsGeometry.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4.0,
                offset: Offset.zero,
                spreadRadius: 1.0
              )
            ]
          ),
          child: Text(
            "Selecione o Card",
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 1.0,
                  offset: Offset(1, 1)
                )
              ]
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: Colors.amber,
            child: Container(
              color: Colors.pink,
              width: 250,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: Page2Controller.instance.listofCards.length,
                itemBuilder:(context, index) {

                  final item = Page2Controller.instance.listofCards[index];
                  final taskItems = Page2Controller.instance.listofTasks;

                  final relation = taskItems
                    .where((e) => e['card_id'] == item['_id'])
                    .toList();

                  return ListTile(
                    title: Text("${item['datecolumn']}"),
                    subtitle: relation.isNotEmpty
                      ? Text("${relation.toList().length} tasks")
                      : Text("Tem nada aqui tiu")
                    ,
                    onTap:() {
                      
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
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
    if(listofTasks.isNotEmpty){
      print("TA CHEGANDO AS TASKS BROW");
    } else {
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