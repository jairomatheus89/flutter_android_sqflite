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
          Container(
            child: Center(
              child: Image.asset(
                'assets/images/agtechtranspa.png',
                fit: BoxFit.contain,
                scale: 0.6,
              ),
            ),
          ),
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
                child: CardsListContainer(),
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

  late bool isLoading = true;

  final sexolandia = DataBaseService();
  List<Widget> cardList = [];

  var sleepzin = const Duration(seconds: 3);

  void initState(){
    super.initState();
    isLoading = true;
  }

  void listCard() async {

    final priquita = await sexolandia.showNameRows();
    var priquitsleng = priquita.length;

    List bucetilda = [];
    for (var i = 0; i < priquitsleng; i++){
      bucetilda.add(priquita[i]['datecolumn'].toString());
      
      cardList.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
        height: 32,
        decoration: BoxDecoration(
          color: const Color.fromARGB(200, 255, 255, 255),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(
          bucetilda[i],
          style: TextStyle(
            color:Colors.green,
            fontSize: 16,
            shadows: [
              Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))
            ]
          ),
        ),
      ));
    }

    await Future.delayed(Duration(seconds: 1));

    setState((){
      isLoading = false;
    });
  } 

  @override
  Widget build(BuildContext context) {

    if (isLoading){
      listCard();
    }

    return Container(
      child: !isLoading 
      ?Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: cardList,
        ),
      ) : CircularProgressIndicator(),
    );
  }
}