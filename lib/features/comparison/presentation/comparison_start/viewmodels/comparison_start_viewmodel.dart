import 'package:flutter/foundation.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/models/comparison_model.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/repositories/comparison_repository_interface.dart';

class ComparisonStartViewModel extends ChangeNotifier {
  ComparisonStartViewModel({
    required IComparisonRepository repository
  }) : _repository = repository; 
  
  final IComparisonRepository _repository;

  ComparisonModel? comparison;

  bool isLoading = false;
  String? error;

  Future<void> startComparison() async {
    isLoading = true;
    
    notifyListeners();

    try {
      final result = await _repository.startComparisonAsync();
      if (result.isSuccess) {
        comparison = result.getValueOrNull();
      }
      else {
        error = result.getErrorOrNull().toString();
      }
    } catch (e) {
      error = "Erro desconhecido.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  } 

  // Future<ComparisonModel> getUndoneComparisons() async {
  //   isLoading = true;
    
  //   notifyListeners();

  //   try {
  //     final result = await _repository.startComparisonAsync();
  //     if (result.isSuccess) {
  //       final comparisons = result.getValueOrNull();
  //       return comparisons;
  //     }
  //     else {
  //       error = result.getErrorOrNull().toString();
  //     }
  //   } catch (e) {
  //     error = "Erro desconhecido.";
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
}