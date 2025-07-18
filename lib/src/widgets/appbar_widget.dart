

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
            style: TextStyle(fontSize: 50),
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}