class ComparisonDraftModel {
  ComparisonDraftModel({
    required this.theme,
    List<String> pros = const [],
    List<String> cons = const [],
  }) : pros = List.unmodifiable(pros),
       cons = List.unmodifiable(cons);
  final String theme;
  final List<String> pros;
  final List<String> cons;

  ComparisonDraftModel copyWith({
    String? theme,
    List<String>? pros,
    List<String>? cons,
  }) => ComparisonDraftModel(
    theme: theme ?? this.theme,
    pros: pros ?? this.pros,
    cons: cons ?? this.cons,
  );
}
