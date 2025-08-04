import 'package:flutter/material.dart';
import './pages/formzin_page.dart';
import './pages/page2_page.dart';
import './pages/about_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState(){
    super.initState();
    Page2Controller.instance.updateListeners();
  }
  
  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
      listenable: AppController.instance,
      builder: (context, _){
        return MaterialApp(
          navigatorKey: navigatorKey,
          initialRoute: '/',
          routes:{
            '/': (context) => const Formzin(),
            '/page2': (context) => const Page2Page(),
            '/aboutpage': (context) => const AboutPage(),
            '/dbDeleted': (context) => const NoDB(),
          }
        );
      } 
    );
    
  }
}


class NoDB extends StatelessWidget {
  const NoDB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 60,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.green,
                padding: EdgeInsetsGeometry.only(top: 69),
                strokeAlign: 10,
                strokeWidth: 10,
                
              ),
              Text(
                "Banco de Dados deletado, reinicie o aplicativo para reiniciar o banco!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.green,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.black,
                      offset: Offset(1, 1)
                    )
                  ]
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}

class AppController extends ChangeNotifier{

  static final AppController instance = AppController._();
  AppController._();


  bool existingDataBase = true;

  void cardDeleted(){
    navigatorKey.currentState?.pushReplacementNamed('/page2');
    notifyListeners();
  }

  void deletedDataBase(){
    existingDataBase = false;
    if (!existingDataBase){
      navigatorKey.currentState?.pushReplacementNamed('/dbDeleted');
    }
    notifyListeners();
  }

}