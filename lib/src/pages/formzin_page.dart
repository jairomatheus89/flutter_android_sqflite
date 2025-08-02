import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';
import '../services/database_service.dart';
import '../widgets/background_widget.dart';
import '../models/card_day.model.dart';
import '../models/task_card_model.dart';

class Formzin extends StatefulWidget {
  const Formzin({super.key});

  @override
  State<Formzin> createState() => _FormzinState();
}

class _FormzinState extends State<Formzin> {

  Widget sucessFloatButCard = Container(
    width: 200,
    height: 30,
    color: Colors.green,
    child: Center(
      child: Text(
        "CARD SALVO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
      )
    ),
  );

  Widget failFloatButCard = Container(
    width: 200,
    height: 30,
    color: Colors.red,
    child: Center(
      child: Text(
        "salve um cardzin ai",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    print(FormzinPageController.instance.sucessCreateCard);

    WidgetsBinding.instance.addPostFrameCallback((_){
      FormzinPageController.instance.resetsucessinCreateCard();
    });

    return Scaffold(
      appBar: const AppBarWidget(),
      floatingActionButton: AnimatedBuilder(
        animation: FormzinPageController.instance,
        builder: (context, _) {
          return FormzinPageController.instance.sucessCreateCard
            ? sucessFloatButCard
            : failFloatButCard;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          BackgroundWidget(),
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
          child: ListView(
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

    FormzinPageController.instance.resetsucessinCreateCard();

    setState((){
      selectedDate = pickedDate;
    });

    FormzinPageController.instance.dateCardSet = selectedDate;
    FormzinPageController.instance.resetAlertzin();
    FormzinPageController.instance.updateMessage();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedDate = null;
    });

    return SizedBox(
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
            FormzinPageController.instance.dateCardSet != null
            ?'Card de: ${FormzinPageController.instance.dateCardSet!.day}/${FormzinPageController.instance.dateCardSet?.month}/${FormzinPageController.instance.dateCardSet?.year}'
            : 'Selecione uma data!', style: TextStyle(
              fontSize: 18,
              color: FormzinPageController.instance.dateCardSet != null? Colors.green : Colors.red,
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
  var db = DataBaseService();
  bool isLoading = true;
  bool? cardExist;

  String currentTaskWrite = "";
  List<TaskCardModel> taskszinhas = [];

  var taskInputController = TextEditingController();

  final ScrollController _taskScrollControll = ScrollController();

  @override
  void initState(){
    
    super.initState();
    isLoading = true;
  }

  void addTaksColumnController(){

    FormzinPageController.instance.tasksDescs = currentTaskWrite;

    FormzinPageController.instance.addTaksColumn();

    setState(() {
      currentTaskWrite = "";
      taskInputController.clear();
    });

  }

  @override
  void dispose(){

    _taskScrollControll.dispose();
    super.dispose();
  }

  Future<void> checkExistingCard(cardDate) async {
    bool check = await db.checkCardExist(cardDate);
    setState(() {
      cardExist = check;
    });
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_){
      if (_taskScrollControll.hasClients){
        _taskScrollControll.animateTo(
          _taskScrollControll.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastEaseInToSlowEaseOut
        );

      }
    });

    var dateSetted = FormzinPageController.instance.dateCardSet;
    String dateSettedString = "${dateSetted?.day}/${dateSetted?.month}/${dateSetted?.year}";
    checkExistingCard(dateSettedString);

    if (dateSetted != null && cardExist == false){
      isLoading = false;
    } else {
      FormzinPageController.instance.tasksColumnWidget = [];
      isLoading = true;  
    }

    if (isLoading){
      return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(100, 76, 175, 79),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(100, 0, 0, 0),
              blurRadius: 6.0,
              spreadRadius: 1.0,
              offset: Offset(0, 0)
            )
          ]
        ),
        width: 260,
        height: 220,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              CircularProgressIndicator(
                semanticsLabel: "Meu piru",
                strokeAlign: 4,
                strokeCap: StrokeCap.butt,
                strokeWidth: 6,
                color: Colors.green,
                backgroundColor: Colors.red,
                trackGap: 10,
              ),
              Text(
                "Data nao inserida, ou ja existente. Tente outra!",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 1.0,
                      offset: Offset(1, 1)
                    )
                  ]
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 153, 0, 255),
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
      width: 260,
      height: 280,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadiusDirectional.vertical(top:Radius.circular(10)),
            ),
            height: 69,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                    if(currentTaskWrite.isEmpty){
                      FormzinPageController.instance.notEmptyTask();
                      return;
                    }
                    addTaksColumnController();
                  },
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.black,
                    iconSize: 20,
                    shape: CircleBorder(),

                  ),
                  label: Icon(Icons.add),
                ),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    maxLength: 20,
                    controller: taskInputController,
                    onChanged:(value) {
                      currentTaskWrite = value;
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: "Task",
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: "Insira uma task",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2
                        )
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.pink,
              width: 234,
              child: ListView(
                controller: _taskScrollControll,
                children: FormzinPageController.instance.tasksColumnWidget,
              ),
            ),
          )
        ],
      ),
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
        return Container(
          color: Colors.amber,
          height: 90,
          width: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 0,
            children: [
              Container(
                alignment: Alignment.center,
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      offset: Offset(0,0)
                    )
                  ]
                ),
                child: GestureDetector(
                  onTap:()async {
                    
                    final db = DataBaseService();
                    try{
                      
                      await db.showCards();
                      FormzinPageController.instance.dateCardSet = null;
                      FormzinPageController.instance.resetAlertzin();
                    } catch (e) {
                      FormzinPageController.instance.dateCardSet = null;
                      FormzinPageController.instance.temNemTable();
                    }
                    
                  },
                  child: Text(
                    "SHOW TABLE",
                    style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1,1))]),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      offset: Offset(0,0)
                    )
                  ]
                ),
                child: GestureDetector(
                  onTap:() async {
                    // Pegando dados do card e criando o Map
                    DateTime? dateSet = FormzinPageController.instance.dateCardSet;  
                    if(dateSet != null){
                      String dateSetString = "${dateSet?.day}/${dateSet?.month}/${dateSet?.year}";
                      var tasksCardModel = FormzinPageController.instance.taskCardModels;

                      CardDayModel cardMap = CardDayModel(
                        date: dateSetString,
                        tasks: tasksCardModel,
                        scheduledAt: dateSet
                      );

                      var db = DataBaseService();

                      try {

                        await db.insertCard(cardMap);
                        FormzinPageController.instance.clearTasksCardsModel();
                        FormzinPageController.instance.sucessinCreateCard();
                      } catch (e) {
                        FormzinPageController.instance.clearTasksCardsModel();
                        throw Exception("Error no front: $e");
                      }
                    } else {
                      print("Data nula paewzao");
                    }    
                    FormzinPageController.instance.clearTasksCardsModel();
                    FormzinPageController.instance.temNadaAqui();
                  },
                  child: Text(
                    "SAVE CARD",
                    style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1,1))]),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      offset: Offset(0,0)
                    )
                  ]
                ),
                child: GestureDetector(
                  onTap:() async {
                    final db = DataBaseService();
                    try{

                      await db.droptable();
                      return FormzinPageController.instance.tableDeletedson();
                    } catch (e){
                      return FormzinPageController.instance.temNemTable();
                    }

                  },
                  child: Text(
                    "DELETE TABLE",
                    style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1,1))]),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      offset: Offset(0,0)
                    )
                  ]
                ),
                child: GestureDetector(
                  onTap:() async {
                    var db = DataBaseService();

                    try{
                      await db.showTasks();
                    } catch (e) {
                      throw Exception(e);
                    }
                  },
                  child: Text(
                    "Show Tasks",
                    style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1,1))]),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class FormzinPageController extends ChangeNotifier {

  static final FormzinPageController instance = FormzinPageController._();

  FormzinPageController._();

  String tasksDescs = '';

  DateTime? dateCardSet;

  List<Widget> tasksColumnWidget = [];
  List<TaskCardModel> taskCardModels = [];

  String taskCount = '';

  bool sucessCreateCard = false;


  Widget alertMessage = Text('');
  Widget jaTemEssaData = Text('Ja existe um card com esta data!', style: TextStyle(color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
  Widget temNadaAquiPat = Text('Selecione uma data e ao menos uma task', style: TextStyle(color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
  Widget tableDeleted = Text('Tabela Deletada!', style: TextStyle(backgroundColor: Colors.black, color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.white, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
  Widget temNemCardAi = Text('Tem nem Card aqui tiu!...', style: TextStyle(color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
  Widget onetaskMinimum = Text('O Card deve ter ao menos uma Task!', style: TextStyle(color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
  Widget lotadoDeTask = Text('Limite Maximo de Tasks! 10/10', style: TextStyle(color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
  Widget notEmptyTaskTextField = Text('Digite algo no campo da Task!', style: TextStyle(color: Colors.red, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);

  

  

  void sucessinCreateCard(){
    sucessCreateCard = true;
    notifyListeners();
  }
  void resetsucessinCreateCard(){
    sucessCreateCard = false;
    notifyListeners();
  }


  void resetAlertzin(){
    alertMessage = Text('');
    notifyListeners();
  }

  void notEmptyTask(){
    alertMessage = notEmptyTaskTextField;
    notifyListeners();
  }


  void clearTasksCardsModel(){
    taskCardModels = [];
    tasksColumnWidget = [];
    taskCount = '';
    tasksDescs = '';
    alertMessage = Text('');
    dateCardSet = null;
    notifyListeners();
  }

  void addTaksColumn(){

    final tasksColumn = TaskCardModel(
      cardId: 0,
      description: tasksDescs
    );

    if(taskCardModels.length >= 10){
      alertMessage = lotadoDeTask;
      notifyListeners();
      return;
    }

    taskCardModels.add(tasksColumn);

    tasksColumnWidget = List.from(tasksColumnWidget)..add(
      Padding(
        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.white,
              width: 3
            ),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(
            tasksColumn.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
          ),
        ),
      )
    );

    taskCount = "${taskCardModels.length}/10";

    alertMessage = Text(taskCount, style: TextStyle(color: Colors.green, fontSize: 18, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1, 1))]), textAlign: TextAlign.center,);
    notifyListeners();
    tasksDescs = '';
  }

  void onetaskMin(){
    alertMessage = onetaskMinimum;
    notifyListeners();
  }

  void temNemTable(){
    alertMessage = temNemCardAi;
    notifyListeners();
  }

  void tableDeletedson(){
    alertMessage = tableDeleted;
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


  void updateMessage(){
    notifyListeners();
  }
}