import '../widgets/background_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';
import '../services/database_service.dart';
import '../app.dart';

class Page2Page extends StatefulWidget {
  const Page2Page({super.key});

  @override
  State<Page2Page> createState() => Page2PageState();
}

class Page2PageState extends State<Page2Page> {
  @override
  Widget build(BuildContext context) {
    print("penis");
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
    print("penisDrawer");
    int idCard = Page2Controller.instance.idCardson;

    List<Map<String,dynamic>> cardList = Page2Controller.instance.listofCards;

    var cardzin = cardList.where((e) => e['_id'] == idCard).first;

    return Drawer(
      child: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text(
                "TASKS",
                style: TextStyle(
                  color: Colors.red,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 2,
                      offset: Offset(1, 1)
                    )
                  ],
                  fontSize: 40
                ),
              ),
              Text(
                "Card: ${cardzin['datecolumn']}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1)
                    )
                  ]
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 1.0,
                      offset: Offset.zero
                    )
                  ]
                ),
                width: 234,
                height: 321,
                child: DrawerListBuilder(),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.1, horizontal: 0.1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset.zero,
                      spreadRadius: 1.0,
                      blurRadius: 6.0
                    )
                  ]
                ),
                child: TextButton(
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

  var db = DataBaseService();

  @override
  Widget build(BuildContext context) {
    print("penisDrawerListbuild");

    int idCard = Page2Controller.instance.idCardson;
    List<Map<String,dynamic>> cardList = Page2Controller.instance.listofCards;
    var cardzin = cardList.where((e) => e['_id'] == idCard).first;

    final taskList = Page2Controller.instance.listofTasks;

    final relation = taskList
      .where((e) => e['card_id'] == cardzin['_id'])
      .toList();


    return ListView.builder(
      padding: EdgeInsetsGeometry.all(8.0),
      itemCount: relation.length,
      itemBuilder: (context, index) {

        final item = relation[index];

        return Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white,
              width: 3.0
            )
          ),
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            contentPadding: EdgeInsets.fromLTRB(6,0,4,0),
            horizontalTitleGap: 0,
            title: Container(
              //color: Colors.blue,
              child: Text(
                "${item['description']}",
                style: TextStyle(
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 1.0,
                      offset: Offset(1, 1)
                    )
                  ],
                  color: Colors.white
                ),
              ),
            ),
            trailing: Container(
              width: 30,
              height: 20,
              //color: Colors.pink,
              child: Transform.scale(
                scale: 0.6,
                child: Switch(
                  activeColor: Colors.red,
                  value: item['id_done'] == 1,
                  onChanged: (e) async {
                    try{
                      await db.updateTaskForDone(item['_id']);
                    } catch (e){
                      throw Exception("Ta aqui esta merda!: $e");
                    }
                    setState(() {
                      Navigator.pushReplacementNamed(context, '/page2');
                    });
                  }
                ),
              ),
            ),
          ),
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

    bool existingCards = Page2Controller.instance.checkson;

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

        final doneRelation = relation
          .where((e) => e['id_done'] == 1)
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
                "${doneRelation.length}/${relation.toList().length} tasks cumpridas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12
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
            trailing: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
              ),
              width: 30,
              height: 30,
              child: GestureDetector(
                onTap: () => _deleteCardSure(context, itemIndex),
                child: Icon(
                  Icons.delete,
                  color: const Color.fromARGB(255, 255, 0, 0),
                ),
              ),
            ),
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


Future<void> _deleteCardSure(BuildContext context, Map<String, dynamic>itemIndex){
  var db = DataBaseService();

  return showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text("Deletar Card", style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 0, 0))),
        content: Text("Voce tem certeza que deseja excluir este card?"),

        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              print("CANCELASTES o deletinho do card ${itemIndex['_id']}");
            },
            child: Text("Cancelar")
          ),
          TextButton(
            onPressed: () async{
              try{
                await db.deleteCardFromId(itemIndex['_id']);
                await Page2Controller.instance.checkinExistCards();
                AppController.instance.cardDeleted();

              }catch (e){
                print("nao ta deletano, ta errado algo...");
              }
              
            },
            child: Container(
              padding: EdgeInsetsGeometry.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 255, 0, 0)
              ),
              child: Text(
                "DELETAR",
                style: TextStyle(
                  color: Colors.white,          
                )
              ),
            )
          )
        ],
      );
    }
  );
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

  void updateTaskState(){
    
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