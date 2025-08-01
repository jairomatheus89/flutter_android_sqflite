class TaskCardModel {
  final int? id;
  final int cardId;
  final String description;
  final bool isDone;

  TaskCardModel ({
    this.id,
    required this.cardId,
    required this.description,
    this.isDone = false,
  });

  factory TaskCardModel.fromMap(Map<String, dynamic> map){
    return TaskCardModel(
      id: map['_id'],
      cardId: map['card_id'],
      description: map['description'],
      isDone: map['is_done']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'card_id': cardId,
      'description': description,
    };
  }
}