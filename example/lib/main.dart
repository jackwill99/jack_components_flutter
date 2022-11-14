import 'package:camera/camera.dart';
import 'package:example/ui/themes/darkTheme.dart';
import 'package:example/ui/themes/lightTheme.dart';
import 'package:example/util/main_provider.dart';
import 'package:example/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

// fcm setup
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message.messageId}');
// }

/// work manager background process setup
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print(
        "Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  Workmanager().registerPeriodicTask(
    "task-identifier",
    "simpleTask",
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    frequency: const Duration(hours: 10),
  );

  // fcm setup
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // camera setup
  await availableCameras();

  /// FCM-firebase cloud messaging setup
  // FCMConfig.firebaseSetup(context);

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 812),
      builder: (_, child) {
        return MultiProvider(
          providers: ourProviders(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: ThemeMode.dark,
            theme: LightTheme.light(),
            darkTheme: DarkTheme.dark(),
            initialRoute: "/",
            routes: allRoutes,
          ),
        );
      },
    );
  }
}

/// extension method
///
extension ListUtils<T> on List<T> {
  List<T> addItemInBetween<A extends T>(A item) => isEmpty
      ? this
      : (fold([], (r, element) => [...r, element, item])..removeLast());
}
