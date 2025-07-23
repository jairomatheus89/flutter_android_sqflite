import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          margin:EdgeInsets.fromLTRB(16, 0, 0, 0),
          width: 350,
          height: 350,
          child: Image.asset(
            'assets/images/agtechtranspa.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}