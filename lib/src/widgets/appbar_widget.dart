

import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 6.0, spreadRadius: 2.0)
        ]
      ),
      child: AppBar(
        backgroundColor: Colors.green,
        elevation: 5.0,
        title: Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 46),
            children:[
              TextSpan(
                text: "AG",
                style: TextStyle(
                  color: Colors.red,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2.0,2.0),
                      blurRadius: 0
                    )
                  ]
                ),
              ),
              TextSpan(
                text: "Tech",
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2.0,2.0),
                      blurRadius: 0
                    )
                  ]
                ),
              )
            ]
          ),
        ),
        actions: [
          Container(
            //color: Colors.black,
            width: 160,
            margin: EdgeInsets.fromLTRB(0,0,6,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  color: const Color.fromARGB(100, 255, 193, 7),
                  width: 50,
                  height: 50,
                  child:IconButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed((context),'/');
                    },
                    icon: Image.asset("assets/images/tasklist_ico.png")
                  )
                ),
                Container(
                  color: const Color.fromARGB(100, 33, 149, 243),
                  width: 50,
                  height: 50,
                  child:IconButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed((context),'/page2');
                    },
                    icon: Image.asset("assets/images/tasklist_ico.png")
                  )
                ),
                Container(
                  color: const Color.fromARGB(100, 233, 30, 98),
                  width: 50,
                  height: 50,
                  child:IconButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed((context),'/aboutpage');
                    },
                    icon: Image.asset("assets/images/tasklist_ico.png")
                  )
                ),
              ],
            )
          )       
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}