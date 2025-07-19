import 'package:flutter/material.dart';
import '../widgets/list_column_widget.dart';
import '../services/database_service.dart';
import '../widgets/appbar_widget.dart';

class Formzin extends StatefulWidget {

  const Formzin({super.key});

  @override
  State<Formzin> createState() => _FormzinState();
}

class _FormzinState extends State<Formzin> {
  final GlobalKey<DbListColumnState> _key = GlobalKey<DbListColumnState>();

  Widget successCreateAccountWidget = Text('');

  String nameInput = '';
  final _nameInputController = TextEditingController();

  void clearInputs(){
    setState(() {
      _nameInputController.clear();
      nameInput = '';
    });
  }

  void successfloatMessage(){
    setState(() {
      successCreateAccountWidget = Text(
        'Nome: $nameInput, inserido no banco com sucesso!',
        style: TextStyle(
          color: Colors.green,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 2.0, offset: Offset(1.0, 1.0))
          ]
        ),
        textAlign: TextAlign.center,
      );
    });
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_){
      successCreateAccountWidget = Text('');
    });

    return Scaffold(
      floatingActionButton: successCreateAccountWidget,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      appBar: const AppBarWidget(),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0,0),
                      spreadRadius: 2.0,
                      blurRadius: 6.0
                    )
                  ]
                ),
                child: TextFormField(
                  maxLength: 30,
                  controller: _nameInputController,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                        offset: Offset(1.2, 1.2)
                      )
                    ]
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.green,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0
                      )
                    ),
                    hintText: "Digite seu nome aqui...",
                    hintStyle: TextStyle(color: Colors.red, fontSize: 16),
                    labelText: "Nome",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                    floatingLabelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                          blurRadius: 3.0
                        )
                      ]
                    ),
                  ),
                  onChanged: (e){
                    nameInput = e;
                  },
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6,
                      spreadRadius: 2
                    )
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    side: BorderSide(
                      width: 2.0,
                      color: Colors.white,
                    )
                  ),
                  onPressed: () {
                    if(nameInput == ''){
                      clearInputs();
                      _key.currentState?.reloadNames();
                      setState(() {
                        successCreateAccountWidget = Text('Falha ao inserir nome vazio!...', style: TextStyle(color: Colors.red, fontSize: 18,fontWeight: FontWeight.bold));
                      });
                      return;
                    }
                
                    if(nameInput.length <= 3){
                      clearInputs();
                      setState(() {
                        successCreateAccountWidget = Text('Digite um nome com mais de 3 letras...', style: TextStyle(color: Colors.red, fontSize: 18,fontWeight: FontWeight.bold));
                      });
                      return;
                    }
                
                    DataBaseService inserir = DataBaseService();
                    inserir.insertNameData(nameInput);
                    successfloatMessage();
                    clearInputs();
                    _key.currentState?.reloadNames();
                  },
                  child: Text(
                    "inserir nome!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6.0,
                          offset: Offset(2, 2)
                        )
                      ]
                    )
                  )
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 2,
                      blurRadius: 6
                    )
                  ]
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    side: BorderSide(
                      color: Colors.white,
                      width: 2.0
                    ),
                  ),
                  onPressed: () async{
                    clearInputs();
                    final dbCall = DataBaseService();
                    dbCall.deleteAllUsers();
                    _key.currentState?.reloadNames();
                    setState(() {
                        successCreateAccountWidget = Text('Tabela Deletada Com Sucesso!', style: TextStyle(color: Colors.orange, fontSize: 18,fontWeight: FontWeight.bold));
                      });
                  },
                  child: Text(
                    "DELETE ALL DATA",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(blurRadius: 1, color: Colors.white, offset: Offset(1,1), )
                      ]
                    )
                  )
                ),
              ),
              DbListColumn(key: _key)
            ],
          ),
        ),
      ),
    );
  }
}