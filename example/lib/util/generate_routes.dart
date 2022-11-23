import 'package:example/application.dart';
import 'package:flutter/material.dart';
import 'package:jack_components/ui/page_transition/pageTransition.dart';

Route<dynamic> onGenerateRoute(String name) {
  switch (name) {
    case "restaurant":
    // return JackPageTransition(widget: const RestaurantScreen());
    default:
      return JackPageTransition(widget: const Application());
  }
}
