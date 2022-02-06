import 'dart:ffi';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:skipq_clinic/service/firebase_services/firebase_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  get token async => await _firebaseMessaging.getToken();
  FirebaseMessaging get instance => _firebaseMessaging;
  Future<String?> refreshToken() async {
    await _firebaseMessaging.deleteToken();
    String? token = await _firebaseMessaging.getToken();
    return token;
  }
}

//this function should always be top level function. it should not belong to any class

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await FirebaseService().inittializeFirebase();
  print('here');
  print(message.messageId);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 10,
    channelKey: 'basic_channel',
    title: message.data["title"],
    body: message.data["body"],
  ));
}
