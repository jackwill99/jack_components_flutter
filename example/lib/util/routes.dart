import 'package:example/application.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> allRoutes = <String, WidgetBuilder>{
  // JackWill.routName: (context) => const JackWill(),
  '/': (context) => const Application(),
};
