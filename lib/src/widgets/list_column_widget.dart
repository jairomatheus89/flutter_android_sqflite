import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DbListColumn extends StatefulWidget {

  const DbListColumn({super.key});

  @override
  State<DbListColumn> createState() => DbListColumnState();
}

class DbListColumnState extends State<DbListColumn> {
  

  List<Widget> namesWidgets = [];
  bool isLoading = true;
  final _scrollController = ScrollController();


  void scrollzinEnders(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn
    );
  }

  Future<void> loadingNames() async {
    final db = DataBaseService();
    final tablelist = await db.showCards();

    List list = tablelist;
    final listlentgh = list.length;

    for(var i = 0; i < listlentgh; i++){

      var id = list[i]['_id'].toString();
      var names = list[i]['name'];

      namesWidgets.add(Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(0, 0)
            )
          ],
          color: Colors.green
        ),
        margin: EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(6,0,0,0),
              alignment: Alignment.center,
              //color: Colors.pink,
              child: Text(
                "$id.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 4.0,
                      offset: Offset(2.0, 2.0)
                    )
                  ]
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: Container(
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: Text(
                    "$names",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4.0,
                          offset: Offset(2.0, 2.0)
                        )
                      ]
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
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
      namesWidgets = [];
      isLoading = true;
    });

    loadingNames();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollzinEnders());

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2.0,
            blurRadius: 6.0
          )
        ]
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(4.0),
        child: Scrollbar(
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            children: namesWidgets,
          ),
        ),
      ),
    );
  }
}