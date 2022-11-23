import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Completer<ui.Image> calculateImageSize() {
  Image image = Image.network('https://i.stack.imgur.com/lkd0a.png');
  Completer<ui.Image> completer = Completer<ui.Image>();
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(info.image);
      },
    ),
  );
  return completer;
}
