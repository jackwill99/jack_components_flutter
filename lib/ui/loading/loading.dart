// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JackUILoadingSpinner {
  final BuildContext ctx;
  late BuildContext context2;
  final String title;
  JackUILoadingSpinner({
    this.title = "",
    required this.ctx,
  });

  void closeLoadingSpinner() {
    Navigator.of(context2).pop();
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
        context2 = context;
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
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
        color: const Color.fromRGBO(39, 37, 95, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      width: 110,
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(
            radius: 15.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
