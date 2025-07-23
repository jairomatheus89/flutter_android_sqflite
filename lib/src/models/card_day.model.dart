import './task_card_model.dart';

class CardDayModel {
  final int? id;
  final String date;
  final List <TaskCardModel> tasks;

  CardDayModel({this.id, required this.date, this.tasks = const []});

  factory CardDayModel.fromMap(Map<String, dynamic> map){
    return CardDayModel(
      id: map['_id'],
      date: map['datecolumn'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      '_id': id,
      'datecolumn': date,
    };
  }
}