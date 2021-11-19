import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/screens/homepage/widget/bottom_navigation_bar.dart';
import 'package:booktokenclinicapp/screens/homepage/widget/homepage.dart';
import 'package:booktokenclinicapp/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: bottomNavigationBar(context),
      // appBar: AppBar(title: Text('BookTokenUser')),
      body: SafeArea(
        child: Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
          int currentIndex = clinicProvider.bottomNavIndex;

          if (currentIndex == 0) {
            return HomePageWidget();
          }
          return Container();
          // else if (currentIndex == 1) {
          //   return ProfileScreen();
          // } else if (currentIndex == 2) {
          //   return Text('3');
          // } else {
          //   return Text('4');
          // }
        }),
      ),
    );
  }
}
