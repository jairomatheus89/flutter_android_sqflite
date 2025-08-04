import 'package:flutter/material.dart';
import '../widgets/appbar_widget.dart';
import '../pages/formzin_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/background_widget.dart';
import '../services/database_service.dart';
import '../app.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {

    final Uri gitHubUrl = Uri.parse('https://github.com/jairomatheus89');
    final Uri linkedinUrl = Uri.parse('https://www.linkedin.com/in/jairomatheus89');

    String titleAboutmsg = "Projeto Mobile Flutter w/SQfLite";
    String bodyAboutmsg = "Meu nome é Jairo Paulino, Estou a procura de estágio na area de programação/desenvolvimento de software. Agora no segundo semestre de 2025 vou para meu 2° periodo(começei em janeiro), porém ja acompanho conteúdos relacionados a programação e tecnologia desde o inicio da quarentena do Covid-19. Tenho um conhecimento basico de Web, protocolo HTTP, API's REST, leve noção de WebSockets. Ja fiz projetos academicos com Python, e ja pratiquei uns projetos com NestJS, Angular e PostgreSQL rodando em live em VPS com Node(backend) e Nginx(frontend). Enfim, segue abaixo meus links:\n";

    return Scaffold(
      appBar: AppBarWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        alignment: Alignment.center,
        width: 180,
        height: 25,
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
          onTap:() => _deleteDbSure(context),
          child: Text(
            "Deletar Banco de Dados",
            style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 1.0, offset: Offset(1,1))]),
          ),
        ),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          Center(
            child: Container(
              margin: EdgeInsetsGeometry.only(bottom: 40),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(70, 0, 0, 0),
                    spreadRadius: 2,
                    blurRadius: 6
                  )
                ],
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(140, 244, 67, 54),
                    const Color.fromARGB(140, 76, 175, 79),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              width: 300,
              height: 460,
              child: Padding(
                padding: EdgeInsetsGeometry.all(14),
                child: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 3.0,
                  child: ListView(
                    children: [
                      Text(
                        titleAboutmsg,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 3.0
                            )
                          ]
                        ),
                      ),
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: bodyAboutmsg,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                shadows: [
                                  Shadow(
                                    color:Colors.black,
                                    blurRadius: 1.0,
                                    offset: Offset(1.0, 1.0)
                                  )
                                ]
                              )
                            ),
                          ]
                        )
                      ),
                      Column(
                        spacing: 10.0,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if(!await launchUrl(gitHubUrl)){
                                throw Exception('Cannot launch $gitHubUrl');
                              }
                            },
                            child: Text(
                              "https://github.com/jairomatheus89",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 1.0,
                                    offset: Offset(1, 1)
                                  )
                                ]
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if(!await launchUrl(linkedinUrl)){
                                throw Exception('cannot launch $linkedinUrl');
                              }
                            },
                            child: Text(
                              "www.linkedin.com/in/jairomatheus89",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 14,
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
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

Future<void> _deleteDbSure(BuildContext context){
  return showDialog(
    context: context,
    builder:(context) {
      return AlertDialog(
        title: Text("DELETAR BANCO DE DADOS", textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 18)),
        content: Text("Após o banco de dados for deletado, o aplicativo deverá ser reiniciado. Tem certeza que deseja deleta-lo?", textAlign: TextAlign.center,),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              print("CANCELASTES!");
            },
            child: Text("Cancelar")
          ),
          TextButton(
            onPressed: () async {
              final db = DataBaseService();
              try{
                await db.droptable();   
                return AppController.instance.deletedDataBase();
              } catch (e){
                return FormzinPageController.instance.temNemTable();
              }
              // Navigator.of(context).pop();
              // print("DELETASTES!");
            },
            child: Container(
              padding: EdgeInsetsGeometry.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 255, 0, 0)
              ),
              child: Text(
                "DELETAR",
                style: TextStyle(
                  color: Colors.white,          
                )
              ),
            )
          )
        ],
      );
    },
  );
}