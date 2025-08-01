import '../pages/formzin_page.dart';
import './task_card_model.dart';

class CardDayModel {
  final int? id;
  final String date;
  final List <TaskCardModel> tasks;

  CardDayModel({
    this.id,
    required this.date,
    required List <TaskCardModel> tasks,

  }) : tasks = tasks {
    if (tasks.isEmpty){
      FormzinPageController.instance.onetaskMin();
      throw Exception("NO PUEDE FICAR VAZIO MI AMIGUITOOOOOO!");
    }
  }


  factory CardDayModel.fromMap(Map<String, dynamic> map){
    return CardDayModel(
      id: map['_id'],
      date: map['datecolumn'],
      tasks: [],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      '_id': id,
      'datecolumn': date,
    };
  }
}