import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  Timer? _timer;

  /// ## (Debouncer) Delay Search while typing
  /// declare Debouncer in your builder
  /// and use and call this method
  /// ```dart
  ///
  /// final debouncer = Debouncer(milliseconds: 1000); // in your builder
  ///
  ///  TextFormField(
  ///  onChanged: (value) {
  ///       debounce.run((){
  ///         print(value);
  ///       })
  ///     }
  ///   )
  ///```
  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
