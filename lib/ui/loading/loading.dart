// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JackUILoadingSpinner {
  final BuildContext ctx;
  final String title;
  final Color? titleColor;
  final Color? spinColor;
  final Color? backgroundColor;
  final Color? scaffoldColor;
  JackUILoadingSpinner({
    required this.ctx,
    this.title = "",
    this.titleColor,
    this.spinColor,
    this.backgroundColor,
    this.scaffoldColor,
  });

  late BuildContext context2;
  set setContext(BuildContext value) {
    context2 = value;
  }

  BuildContext get getContext {
    return context2;
  }

  void closeLoadingSpinner() {
    final ctx = getContext;
    Navigator.of(ctx).pop();
  }

  void showLoadingSpinner() async {
    showGeneralDialog(
      context: ctx,
      barrierDismissible: false,
      // transitionDuration: const Duration(milliseconds: 500),
      // transitionBuilder: (context, animation, secondaryAnimation, child) {
      //   return FadeTransition(
      //     opacity: animation,
      //     child: ScaleTransition(
      //       scale: animation,
      //       child: child,
      //     ),
      //   );
      // },
      pageBuilder: (context, animation, secondaryAnimation) {
        setContext = context;
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: scaffoldColor,
            // backgroundColor: Colors.transparent,
            body: Center(child: loadingWidget()),
          ),
        );
      },
    );
  }

  Widget loadingWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromRGBO(39, 37, 95, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      width: 110,
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            radius: 15.0,
            color: spinColor ?? Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: titleColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
