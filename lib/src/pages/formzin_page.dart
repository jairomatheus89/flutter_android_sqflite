import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';

class Formzin extends StatelessWidget {
  const Formzin({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppBarWidget(),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0,20,0,0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 2,
                    blurRadius: 6
                  )
                ],
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.green,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              width: 300,
              height: 520,
              child: TaskForm(),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});


  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DateSelectionState(),
          TasksColumn(),
          Butzin()
        ],
      ),
    );
  }
}

class DateSelectionState extends StatefulWidget {
  const DateSelectionState({super.key});

  @override
  State<DateSelectionState> createState() => _DateSelectionStateState();
}

class _DateSelectionStateState extends State<DateSelectionState> {
  DateTime? selectedDate;

  bool datepicked = false;

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    selectedDate = pickedDate;

    setState(() {
      datepicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedDate = null;
    });

    return Container(
      width: 300,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1.0,
            blurRadius: 6.0
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: _selectDate,
            child: Container(
              alignment: Alignment.center,
              width: 142,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1.0,
                    blurRadius: 6.0,
                    offset: Offset.zero
                  )
                ]
              ),
              child: Text(
                "Selecione a Data",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 1.0,
                      offset: Offset(1, 1)
                    )
                  ]
                ),
              ),
            )
          ),
          Text(
            selectedDate != null
            ?'Card de: ${selectedDate!.day}/${selectedDate?.month}/${selectedDate?.year}'
            : 'no data selected',
          ),
        ],
      ),
    );
  }
}

class TasksColumn extends StatefulWidget {
  const TasksColumn({super.key});

  @override
  State<TasksColumn> createState() => _TaskColumnState();
}

class _TaskColumnState extends State<TasksColumn> {
  @override

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6.0,
            spreadRadius: 1.0,
            offset: Offset(0, 0)
          )
        ]
      ),
      width: 220,
      height: 220,
    );
  }
}

class Butzin extends StatelessWidget {
  const Butzin({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {

      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 1.0,
              blurRadius: 6.0,
              offset: Offset(0, 0)
            )
          ]
        ),
        width: 130,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          "Salvar Card",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 6.0,
                offset: Offset(1, 1)
              )
            ]
          ),
        ),
      )
    );
  }
}