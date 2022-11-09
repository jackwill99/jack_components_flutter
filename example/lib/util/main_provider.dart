import 'package:example/Z+security/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> ourProviders() {
  return [
    ChangeNotifierProvider(create: (context) => UserInfo()),
    // ChangeNotifierProvider(create: (context) => JackNetworkConnectivity()),
    // ChangeNotifierProvider(create: (context) => CameraProvider()),
  ];
}
