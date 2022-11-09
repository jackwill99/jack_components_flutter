import 'package:flutter/material.dart';

class JackUISnackBar {
  SnackBar snackBar({
    String? dismiss,
    Function? onDismiss,
    Duration? duration,
    required Icon icon,
    required Text title,
    required Color backgroundColor,
  }) {
    return SnackBar(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: icon,
          ),
          Flexible(child: title),
        ],
      ),
      action: dismiss != null
          ? SnackBarAction(
              label: dismiss,
              onPressed: () => onDismiss!(),
            )
          : null,
      duration: duration ?? const Duration(seconds: 10),
      elevation: 1,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
    );
  }
}
