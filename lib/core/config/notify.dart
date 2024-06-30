import 'package:flutter/material.dart';
import 'package:testinger/di/injects.dart';
import 'package:testinger/routes/routes.dart';

enum NotifyType { error, success, general }

class ShowNotifyDuration {
  static const Duration long = Duration(seconds: 4);
  static const Duration short = Duration(seconds: 2);
}

class ShowNotify {
  static error({
    String? msg,
    Duration? duration,
    TextStyle? textStyle,
    ShapeBorder? shape,
  }) {
    show(
      msg: msg,
      notifyType: NotifyType.error,
      duration: duration,
      textStyle: textStyle,
      shape: shape,
    );
  }

  static success({
    String? msg,
    Duration? duration,
    TextStyle? textStyle,
    ShapeBorder? shape,
  }) {
    show(
      msg: msg,
      notifyType: NotifyType.success,
      duration: duration,
      textStyle: textStyle,
      shape: shape,
    );
  }

  static show({
    String? msg,
    NotifyType notifyType = NotifyType.general,
    Duration? duration,
    TextStyle? textStyle,
    ShapeBorder? shape,
  }) {
    Color? bgColor;
    ShapeBorder? shapeBorder = shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));

    BuildContext? ctx = inject<AppRouter>().navigatorKey.currentContext;
    if (ctx == null) return;

    TextStyle? style = Theme.of(ctx).textTheme.bodyMedium;

    Duration baseDuration;

    if (duration != null) {
      baseDuration = duration;
    } else {
      List<String> messageData = msg?.trim().split(" ") ?? [];
      if (messageData.isNotEmpty) {
        if (messageData.length <= 1) {
          baseDuration = const Duration(milliseconds: 1500);
        } else if (messageData.length > 1 && messageData.length <= 3) {
          baseDuration = ShowNotifyDuration.short;
        } else if (messageData.length > 3 && messageData.length <= 6) {
          baseDuration = ShowNotifyDuration.long;
        } else {
          baseDuration = const Duration(seconds: 6);
        }
      } else {
        baseDuration = ShowNotifyDuration.short;
      }
    }

    switch (notifyType) {
      case NotifyType.error:
        style = textStyle ?? style?.copyWith(color: Colors.white);
        bgColor = bgColor ?? Colors.red;
        break;
      case NotifyType.success:
        style = textStyle ?? style?.copyWith(color: Colors.white);
        bgColor = bgColor ?? Colors.green;
        break;
      case NotifyType.general:
        style = textStyle ?? style?.copyWith(color: Colors.white);
        bgColor = bgColor ?? Colors.black54;
        break;
    }

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: bgColor.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        content: Text(msg ?? 'Unknown', style: style),
        duration: baseDuration,
        shape: shapeBorder,
      ),
    );
  }
}
