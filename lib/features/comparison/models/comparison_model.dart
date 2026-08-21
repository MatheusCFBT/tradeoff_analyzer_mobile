class ComparisonModel {
  final String id;
  final String userId;
  final bool isDone;
  final String topic;
  final List<ArgumentModel> pros;
  final List<ArgumentModel> cons;
  final Decision? decision;

  ComparisonModel({
    required this.id,
    required this.userId,
    required this.isDone,
    required this.topic,
    required this.pros,
    required this.cons,
    this.decision
  });
}

class ArgumentModel{
  final String id;
  final String comparisonId;
  final String description;

  ArgumentModel({
    required this.id,
    required this.comparisonId,
    required this.description
  });
}

enum Decision { //TODO VALIDAR ENUMS PARA MAIS CONDIZENTE COM O DOMINIO
  undecided,
  pros,
  cons
}