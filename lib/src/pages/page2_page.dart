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

    return Scaffold(
      appBar: AppBarWidget(),
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
  List<Widget> cardList = [];

  @override
  void initState(){
    super.initState();
    existingCards = Page2Controller.instance.checkson;
    Page2Controller.instance.updateListeners();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Page2Controller.instance.updateListeners();
    });

    if (!existingCards){
      return Text("Procurando cards\n(Não há cards criados)", textAlign: TextAlign.center,);
    }

    return Text("TOMA AQUI TEUS CARDS PIRANHA!");
  }
}

class Page2Controller extends ChangeNotifier{

  //Estrutura singleton
  static final Page2Controller instance = Page2Controller._();
  Page2Controller._();
  //Estrutura singleton//

  var db = DataBaseService();
  bool checkson = false;

  Future<bool> checkinExistCards() async {
    try {
      checkson = await db.existJustOneCard();
    } catch (e){

      throw ArgumentError("NEM TEM CARDS MEU FI!");
    }
    
    return checkson;
  }
  
  void updateListeners(){
    checkinExistCards();
    notifyListeners();
  }

}