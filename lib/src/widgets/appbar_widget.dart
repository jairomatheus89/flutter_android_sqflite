

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
        automaticallyImplyLeading: false,
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
            //color: Colors.white,
            width: 160,
            height: 50,
            margin: EdgeInsets.fromLTRB(0,0,6,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0,1,0,0),
                  alignment: Alignment.center,
                  // decoration: BoxDecoration(
                  //   color: Colors.amber,
                  //   shape: BoxShape.circle,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black,
                  //       spreadRadius: 3.0,
                  //       blurRadius: 4.0,
                  //       offset: Offset.zero,
                  //     )
                  //   ]
                  // ),
                  height: 40,
                  child:IconButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed((context),'/');
                    },
                    icon: SizedBox(
                      child: Icon(
                        color: Colors.white,
                        shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 4.0
                        )
                      ],
                        Icons.add_circle_outline,
                      ),
                    )
                  )
                ),
                SizedBox(
                  // decoration: BoxDecoration(
                  //   color: Colors.blue,
                  //   shape: BoxShape.circle,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black,
                  //       spreadRadius: 3.0,
                  //       blurRadius: 6.0,
                  //       offset: Offset.zero
                  //     )
                  //   ],
                  // ),
                  height: 40,
                  child:IconButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed((context),'/page2');
                    },
                    icon: Icon(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 4.0
                        )
                      ],
                      Icons.list_alt_outlined
                    )
                  )
                ),
                SizedBox(
                  // decoration: BoxDecoration(
                  //   color: Colors.pink,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black,
                  //       spreadRadius: 3.0,
                  //       blurRadius: 6.0,
                  //       offset: Offset.zero
                  //     )
                  //   ],
                  //   shape: BoxShape.circle
                  // ),
                  height: 40,
                  child:IconButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed((context),'/aboutpage');
                    },
                    icon: Icon(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 4.0
                        )
                      ],
                      Icons.info
                    )
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