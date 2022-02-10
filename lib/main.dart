import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/screens/splash_screen/splash_screen.dart';
import 'package:skipq_clinic/service/api_service.dart';
import 'package:skipq_clinic/service/firebase_services/auth_service.dart';
import 'package:skipq_clinic/service/firebase_services/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart';

final getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ClinicProvider())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "SkipQ Clinic", theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Lato'), home: SplashScreen()));
  }
}
