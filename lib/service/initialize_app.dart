import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:skipq_clinic/config/app_config.dart';
import 'package:skipq_clinic/main.dart';
import 'package:skipq_clinic/screens/splash_screen/splash_screen.dart';
import 'package:skipq_clinic/service/api_service.dart';
import 'package:skipq_clinic/service/firebase_services/auth_service.dart';
import 'package:skipq_clinic/service/firebase_services/fcm_service.dart';
import 'package:skipq_clinic/service/firebase_services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';

//All initialization goes here

class InitializeApp {
  Future<bool> initialze(context) async {
    try {
      FirebaseApp _firebaseApp = await FirebaseService().inittializeFirebase();
       
      getIt.registerLazySingleton(() => ApiService());
      getIt.registerLazySingleton(() => FirebaseAuthService());
      getIt.registerLazySingleton(() => FcmService());
      getIt.registerSingleton(AppConfig());
      await getIt.get<AppConfig>().loadAppConfig();
      await getIt.get<ApiService>().addCookieInceptor();
      await getIt.get<ApiService>().addCookieInceptor();
      AwesomeNotifications().initialize(
          // set the icon to null if you want to use the default app icon
          null,
          [
            NotificationChannel(
                channelGroupKey: 'basic_channel_group',
                channelKey: 'basic_channel',
                channelName: 'Basic notifications',
                channelDescription: 'Notification channel for basic tests',
                defaultColor: Color(0xFF9D50DD),
                importance: NotificationImportance.Max,
                ledColor: Colors.white)
          ],
          // Channel groups are only visual and are not required
          channelGroups: [NotificationChannelGroup(channelGroupkey: 'basic_channel_group', channelGroupName: 'Basic group')],
          debug: true);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
