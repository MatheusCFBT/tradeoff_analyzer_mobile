import 'package:flutter/material.dart';

import 'argument_management/argument_change.dart';
import 'argument_management/argument_management_sheet.dart';
import 'argument_management/argument_modal_routes.dart';

export 'argument_management/argument_change.dart';

Future<ArgumentChange?> showArgumentManagement(
  BuildContext context, {
  required String argument,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  final navigator = Navigator.of(context);
  return navigator.push(
    ArgumentBottomSheetRoute<ArgumentChange>(
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
