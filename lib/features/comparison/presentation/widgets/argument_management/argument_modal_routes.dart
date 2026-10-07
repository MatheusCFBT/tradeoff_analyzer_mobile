import 'dart:ui';

import 'package:flutter/material.dart';

/// The filter belongs to the barrier overlay, below the active modal content.
mixin _BlurredBarrier<T> on ModalRoute<T> {
  @override
  Widget buildModalBarrier() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: super.buildModalBarrier(),
    );
  }
}

class ArgumentBottomSheetRoute<T> extends ModalBottomSheetRoute<T>
    with _BlurredBarrier<T> {
  ArgumentBottomSheetRoute({
    required super.builder,
    required double maxHeight,
    super.capturedThemes,
    super.barrierLabel,
  }) : super(
         isScrollControlled: true,
         useSafeArea: true,
         showDragHandle: true,
         modalBarrierColor: Colors.black.withValues(alpha: .35),
         backgroundColor: Colors.white,
         shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
         ),
         constraints: BoxConstraints(maxWidth: 440, maxHeight: maxHeight),
       );
}

class ArgumentDialogRoute<T> extends DialogRoute<T> with _BlurredBarrier<T> {
  ArgumentDialogRoute({required super.context, required super.builder})
    : super(
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: .35),
      );
}
