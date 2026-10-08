import 'package:flutter/material.dart';

import '../../models/argument_change_model.dart';
import 'argument_management/argument_management_sheet.dart';
import 'argument_management/argument_modal_routes.dart';

export '../../models/argument_change_model.dart';

Future<ArgumentChangeModel?> showArgumentManagement(
  BuildContext context, {
  required String argument,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  final navigator = Navigator.of(context);
  return navigator.push(
    ArgumentBottomSheetRoute<ArgumentChangeModel>(
      builder: (_) => ArgumentManagementSheet(argument: argument),
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      maxHeight: MediaQuery.sizeOf(context).height * .85,
    ),
  );
}
