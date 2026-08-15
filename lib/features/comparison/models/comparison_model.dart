class ComparisonModel {
  final String id;
  final String userId;
  final bool isDone;
  final String topic;
  final List<ArgumentModel> pros;
  final List<ArgumentModel> cons;
  final Decision? decision;

  ComparisonModel({
    required id
  })
}

class ArgumentModel{
  final String id;
  final String description;
}

enum Decision {
  undecided,
  
}