// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Consts {
  Consts._();

  static double padding = 16.h;
  static double avatarRadius = 40.h;
}

class JackUIDialog extends StatelessWidget {
  final Text? title, description;
  final Widget? icon;
  final Widget? topImage;
  final Widget? body;
  final Widget? button;

  const JackUIDialog({
    Key? key,
    this.icon,
    this.description,
    this.title,
    this.topImage,
    this.body,
    this.button,
  }) : super(key: key);

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                if (topImage != null) topImage!,
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                if (title != null)
                  title! // fontSize: 24.0,fontWeight: FontWeight.w700, height: 1.1,
                ,
                15.verticalSpace,
                if (description != null)
                  description! // fontSize: 16.0,height: 1.2,
                ,
                if (body != null) 30.verticalSpace,
                if (body != null) body! // fontSize: 16.0,height: 1.2,
                ,
                20.verticalSpace,
                if (button != null) button!,
                20.verticalSpace,
              ],
            ),
          ),
          Positioned(
            left: Consts.padding,
            right: Consts.padding,
            child: icon != null ? icon! : Container(),
          )
        ],
      ),
    );
  }
}
