import 'package:flutter/material.dart';

class LoadingDialog {
  final BuildContext context;
  BuildContext? _dialogContext;

  LoadingDialog(this.context);

  void show() {
    if (_dialogContext != null) dismiss();

    showDialog(
      context: context,
      builder: (dCtx) {
        _dialogContext = dCtx;
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void dismiss() {
    try {
      if (_dialogContext != null && Navigator.canPop(_dialogContext!)) {
        Navigator.pop(_dialogContext!);
      }
    } catch (_) {}
  }
}
