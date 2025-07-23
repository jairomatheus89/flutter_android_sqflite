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

  late bool isLoading = true;

  final sexolandia = DataBaseService();
  List<Widget> cardList = [];

  @override
  void initState(){
    super.initState();
    isLoading = true;
  }

    // await Future.delayed(Duration(seconds: 2));


  @override
  Widget build(BuildContext context) {

    return Container(
      child: !isLoading 
      ?SizedBox(
        width: 222,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: cardList,
        ),
      ) : SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          color: Colors.green,
          backgroundColor: Colors.red,
          strokeWidth: 10.0,
        )
      ),
    );
  }
}