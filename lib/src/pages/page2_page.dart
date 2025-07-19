import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';

class Page2Page extends StatelessWidget {
  const Page2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 2,
                blurRadius: 6
              )
            ],
            color: Colors.green,
            borderRadius: BorderRadius.circular(10)
          ),
          width: 250,
          height: 420,
        ),
      )
    );
  }
}