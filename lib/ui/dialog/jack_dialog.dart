// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Consts {
  Consts._();

  static double padding = 16.h;
  static double avatarRadius = 40.h;
}

class JackUIDialog extends StatelessWidget {
  final String? confirmText, undoText;
  final Text? title, description;
  final Function? confirmFunc, undoFunc;
  final Icon? icon;
  final Color? iconBackgroundColor;
  final Widget? topImage;
  final Widget? body;
  final double? fontSize;

  const JackUIDialog(
      {Key? key,
      this.undoText,
      this.undoFunc,
      this.icon,
      this.iconBackgroundColor,
      this.confirmFunc,
      this.confirmText,
      this.description,
      this.title,
      this.topImage,
      this.body,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: (icon != null ? Consts.avatarRadius : 0) + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin:
                EdgeInsets.only(top: icon != null ? Consts.avatarRadius : 0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                topImage != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: topImage!,
                      )
                    : Container(),
                title != null
                    ? title! // fontSize: 24.0,fontWeight: FontWeight.w700, height: 1.1,
                    : Container(),
                16.verticalSpace,
                description != null
                    ? description! // fontSize: 16.0,height: 1.2,
                    : Container(),
                24.verticalSpace,
                body != null
                    ? body! // fontSize: 16.0,height: 1.2,
                    : Container(),
                24.verticalSpace,
                Row(
                  mainAxisAlignment: undoText != null && confirmText != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    undoText != null
                        ? TextButton(
                            onPressed: () {
                              // To close the dialog
                              // Navigator.of(context).pop(false);
                              undoFunc!();
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              side: MaterialStateProperty.all(
                                const BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(39, 37, 95, 1)),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                              ),
                            ),
                            child: Text(
                              undoText!,
                              style: TextStyle(
                                  fontSize: fontSize ?? 18,
                                  color: const Color.fromRGBO(39, 37, 95, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    confirmText != null
                        ? TextButton(
                            onPressed: () {
                              // To close the dialog
                              // Navigator.of(context).pop(true);
                              confirmFunc!();
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              side: MaterialStateProperty.all(
                                const BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(39, 37, 95, 1)),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                              ),
                            ),
                            child: Text(
                              confirmText!,
                              style: TextStyle(
                                  fontSize: fontSize ?? 18,
                                  color: const Color.fromRGBO(39, 37, 95, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            left: Consts.padding,
            right: Consts.padding,
            child: icon != null
                ? CircleAvatar(
                    backgroundColor: iconBackgroundColor ?? Colors.blueAccent,
                    radius: Consts.avatarRadius,
                    child: icon,
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
