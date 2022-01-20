import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Consumer<ClinicProvider> bottomNavigationBar(context) {
  return Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
      unselectedItemColor: Colors.black,
      selectedItemColor: R.color.primaryD1,
      currentIndex: clinicProvider.bottomNavIndex,
      selectedLabelStyle: R.styles.fontColorPrimary.merge(R.styles.fz14Fw700),
      unselectedLabelStyle: R.styles.fz14Fw700,
      onTap: (index) {
        print(index);
        clinicProvider.setBottomNavIndex = index;
      },
      items: [
        bottomNavigatorItem(Icons.home, 'Tokens'),
        bottomNavigatorItem(Icons.schedule_rounded, 'Requests'),
        bottomNavigatorItem(Icons.account_circle_rounded, 'Profile'),
        // bottomNavigatorItem(Icons., 'Profile'),
        // bottomNavigatorItem(Icons.bookmark, ''),
      ],
    );
  });
}

bottomNavigatorItem(IconData icon, String text) {
  return BottomNavigationBarItem(icon: Icon(icon), label: text);
}
