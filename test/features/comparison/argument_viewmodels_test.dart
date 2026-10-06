import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_cons/viewmodels/comparison_cons_viewmodel.dart';
import 'package:tradeoff_analyzer_mobile/features/comparison/presentation/comparison_pros/viewmodels/comparison_pros_viewmodel.dart';

void main() {
  for (final cons in [false, true]) {
    group(cons ? 'Cons mutations' : 'Pros mutations', () {
      late ChangeNotifier notifier;
      late bool Function(int, String) update;
      late bool Function(int) remove;
      late List<String> Function() items;
      late int notifications;

      setUp(() {
        if (cons) {
          final model = ComparisonConsViewModel();
          notifier = model;
          update = model.updateCon;
          remove = model.removeCon;
          items = () => model.cons;
          model.addCon('Duplicado');
          model.addCon('Meio');
          model.addCon('Duplicado');
        } else {
          final model = ComparisonProsViewModel();
          notifier = model;
          update = model.updatePro;
          remove = model.removePro;
          items = () => model.pros;
          model.addPro('Duplicado');
          model.addPro('Meio');
          model.addPro('Duplicado');
        }
        notifications = 0;
        notifier.addListener(() => notifications++);
      });
      tearDown(() => notifier.dispose());

      test('invalid indices and blank updates leave state unchanged', () {
        for (final index in [-1, 3, 100]) {
          expect(update(index, 'Editado'), isFalse);
          expect(remove(index), isFalse);
        }
        expect(update(1, ''), isFalse);
        expect(update(1, '   '), isFalse);
        expect(items(), ['Duplicado', 'Meio', 'Duplicado']);
        expect(notifications, 0);
      });

      test('update trims only selected occurrence and notifies once', () {
        expect(update(2, '  Editado  '), isTrue);
        expect(items(), ['Duplicado', 'Meio', 'Editado']);
        expect(notifications, 1);
      });

      test('removal affects only selected occurrence and notifies once', () {
        expect(remove(2), isTrue);
        expect(items(), ['Duplicado', 'Meio']);
        expect(notifications, 1);
      });

      test('unchanged update succeeds without redundant notification', () {
        expect(update(0, '  Duplicado  '), isTrue);
        expect(items(), ['Duplicado', 'Meio', 'Duplicado']);
        expect(notifications, 0);
      });
    });
  }
}
