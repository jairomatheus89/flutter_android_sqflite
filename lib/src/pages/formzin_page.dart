import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';
import '../services/database_service.dart';

class Formzin extends StatelessWidget {
  const Formzin({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppBarWidget(),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Image.asset(
              'assets/images/agtechtranspa.png',
              scale: 0.6,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0,20,0,0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
            ),
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

  Widget alertzin = FormzinPageController.instance.alertMessage;

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_){
      FormzinPageController.instance.resetAlertzin();
    });

    return ListenableBuilder(
      listenable: FormzinPageController.instance,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DateSelectionState(),
              TasksColumn(),
              FormzinPageController.instance.alertMessage,
              Butzin()
            ],
          ),
        );
      },
      
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

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    setState((){
      selectedDate = pickedDate;
    });

    FormzinPageController.instance.messaginha = selectedDate;
    FormzinPageController.instance.resetAlertzin();
    FormzinPageController.instance.updateMessage();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedDate = null;
    });

    return Container(
      width: 300,
      height: 90,
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
            : 'no data selected', style: TextStyle(
              fontSize: 18,
              color: selectedDate != null? Colors.green : Colors.red,
              shadows: [Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 1.0)]
            ),
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

class Butzin extends StatefulWidget {

  const Butzin({super.key});

  @override
  State<Butzin> createState() => _ButzinState();
}

class _ButzinState extends State<Butzin> {

  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
      listenable: FormzinPageController.instance,
      builder: (context, child) {
        return TextButton(
          onPressed: () async {
            DataBaseService dbService = DataBaseService();
            final cheracu = FormzinPageController.instance.messaginha;
            String cheracuStringify = "${cheracu?.day}/${cheracu?.month}/${cheracu?.year}";

            if (cheracu != null){
              try{
                final piruzin = await dbService.insertCardData(cheracuStringify);
                print("inserido card: $piruzin com sucesso!");
                FormzinPageController.instance.savedcard();

              } catch (e){
                  if(e == 'unique'){
                    FormzinPageController.instance.jatemsapoha();
                  }
              }

            } else {
              FormzinPageController.instance.temNadaAqui();
              print("tem nadas");
            }
            setState(() {
              FormzinPageController.instance.messaginha = null;
            });
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
    );
  }
}


class FormzinPageController extends ChangeNotifier {

  static final FormzinPageController instance = FormzinPageController._();

  FormzinPageController._();

  bool selectedDateFilled = false;

  DateTime? messaginha;

  Widget alertMessage = Text('');

  Widget jaTemEssaData = Text('Ja existe um card com esta data!', style: TextStyle(color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
  Widget temNadaAquiPat = Text('Selecione ao menos uma data!', style: TextStyle(color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
  Widget cardSaved = Text('CARD SALVO COM SUCESSO!', style: TextStyle(color: Colors.green, fontSize: 20, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);

  void resetAlertzin(){
    alertMessage = Text('');
    notifyListeners();
  }

  void temNadaAqui(){
    alertMessage = temNadaAquiPat;
    notifyListeners();
  }

  void jatemsapoha(){
    alertMessage = jaTemEssaData;
    notifyListeners();
  }

  void savedcard(){
    alertMessage = cardSaved;
    notifyListeners();
  }

  void updateMessage(){
    notifyListeners();
  }
}