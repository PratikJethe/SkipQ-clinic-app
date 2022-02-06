import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/resources/resources.dart';
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
        bottomNavigatorItem(Icon(Icons.home), 'Tokens'),
        bottomNavigatorItem(
            Stack(
              children: [
                Icon(Icons.schedule_rounded),
                if (clinicProvider.clinicRequestedTokenList.length != 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(color: R.color.primary, shape: BoxShape.circle),
                    ),
                  )
              ],
            ),
            'Requests'),
        bottomNavigatorItem(Icon(Icons.account_circle_rounded), 'Profile'),
        // bottomNavigatorItem(Icons., 'Profile'),
        // bottomNavigatorItem(Icons.bookmark, ''),
      ],
    );
  });
}

bottomNavigatorItem(Widget icon, String text) {
  return BottomNavigationBarItem(icon: icon, label: text);
}
