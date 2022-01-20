import 'package:booktokenclinicapp/main.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/screens/clinic/pending_token_view.dart';
import 'package:booktokenclinicapp/screens/clinic/request_token_view.dart';
import 'package:booktokenclinicapp/screens/homepage/widget/bottom_navigation_bar.dart';
import 'package:booktokenclinicapp/screens/homepage/widget/homepage.dart';
import 'package:booktokenclinicapp/screens/modal-screen/modal_loading_screen.dart';
import 'package:booktokenclinicapp/screens/profile-page/profile_page_screen.dart';
import 'package:booktokenclinicapp/screens/profile/profile_screen.dart';
import 'package:booktokenclinicapp/service/firebase_services/fcm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FcmService _fcmService = getIt.get<FcmService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // you get data when app is in background or foreground state
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(onBackgroundMessage);


    //terminated state
    FirebaseMessaging.instance.getInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    return 
    
    ModalLoadingScreen(
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar(context),
        // appBar: AppBar(title: Text('BookTokenUser')),
        body: SafeArea(
          child: Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
            int currentIndex = clinicProvider.bottomNavIndex;
          
            if (currentIndex == 0) {
              return PendingTokenView();
            } else if (currentIndex == 1) {
              return RequestTokenView();
            } else if (currentIndex == 2) {
              // return ProfilePage();
              return ProfilePage();
            } else {
              return Text('4');
            }
          }),
        ),
      ),
    );
  }
}
