class ComparisonModel {
  final String id;
  final String userId;
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