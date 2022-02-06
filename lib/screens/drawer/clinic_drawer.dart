import 'package:skipq_clinic/models/clinic_model.dart';
import 'package:skipq_clinic/privarcy/privarcy_policy.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:skipq_clinic/screens/my-subscriptions/subscription_page.dart';
import 'package:skipq_clinic/screens/notification/notification_screen.dart';
import 'package:skipq_clinic/screens/profile/profile_screen.dart';
import 'package:skipq_clinic/screens/profile/widget/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClinicDrawer extends StatefulWidget {
  const ClinicDrawer({Key? key}) : super(key: key);

  @override
  _ClinicDrawerState createState() => _ClinicDrawerState();
}

class _ClinicDrawerState extends State<ClinicDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
      return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: [
            DrawerHeader(
                // decoration: BoxDecoration(color: R.color.primary),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Container(
                  color: R.color.primaryL1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DoctorProfileWidget(
                        width: MediaQuery.of(context).size.width * 0.25,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. ${clinicProvider.clinic.doctorName}',
                              style: R.styles.fz16.merge(R.styles.fontColorWhite),
                            ),
                            // Text('${clinicProvider.clinic.}'),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            Expanded(
                child: ListView(
              children: [
                ListTile(
                  dense: true,
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
                  title: Text(
                    'View Profile',
                    style: R.styles.fz16,
                  ),
                ),
                // Divider(
                //   thickness: 2,
                //   color: R.color.lightGreyish,
                // ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubscriptionPage()));
                  },
                  dense: true,
                  horizontalTitleGap: 1,
                  leading: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  title: Text(
                    'My Subscriptions',
                    style: R.styles.fz16,
                  ),
                ),
                // Divider(
                //   thickness: 2,
                //   color: R.color.lightGreyish,
                // ),
                // ListTile(
                //   dense: true,
                //   onTap: () {
                //     Navigator.of(context).push( MaterialPageRoute(builder: (context) => NotificationScreen()));
                //   },
                //   horizontalTitleGap: 1,
                //   leading: Icon(
                //     Icons.notifications_rounded,
                //     size: 30,
                //   ),
                //   title: Text(
                //     'Notifications',
                //     style: R.styles.fz16,
                //   ),
                // ),
                // Divider(
                //   thickness: 2,
                //   color: R.color.lightGreyish,
                // ),
                // ListTile(
                //   dense: true,
                //   horizontalTitleGap: 1,
                //   leading: Icon(
                //     Icons.account_circle,
                //     size: 30,
                //   ),
                //   title: Text(
                //     'View Profile',
                //     style: R.styles.fz16,
                //   ),
                // ),
                // Divider(
                //   thickness: 2,
                //   color: R.color.lightGreyish,
                // ),
                // ListTile(
                //   dense: true,
                //   horizontalTitleGap: 1,
                //   leading: Icon(
                //     Icons.account_circle,
                //     size: 30,
                //   ),
                //   title: Text(
                //     'View Profile',
                //     style: R.styles.fz16,
                //   ),
                // ),
                // Divider(
                //   thickness: 2,
                //   color: R.color.lightGreyish,
                // ),
                // ListTile(
                //   dense: true,
                //   horizontalTitleGap: 1,
                //   leading: Icon(
                //     Icons.account_circle,
                //     size: 30,
                //   ),
                //   title: Text(
                //     'View Profile',
                //     style: R.styles.fz16,
                //   ),
                // ),
                // Divider(
                //   thickness: 2,
                //   color: R.color.lightGreyish,
                // ),
                // ListTile(
                //   dense: true,
                //   horizontalTitleGap: 1,
                //   leading: Icon(
                //     Icons.account_circle,
                //     size: 30,
                //   ),
                //   title: Text(
                //     'View Profile',
                //     style: R.styles.fz16,
                //   ),
                // ),
                // Divider(
                //   thickness: 2,
                //   color: R.color.lightGreyish,
                // ),
              ],
            )),
            ListTile(
              dense: true,
              horizontalTitleGap: 1,
              leading: Icon(
                Icons.logout,
                size: 30,
              ),
              title: Text(
                'Privacy Policy',
                style: R.styles.fz16,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivarcyPolicy()));
              },
            ),
            ListTile(
              dense: true,
              horizontalTitleGap: 1,
              leading: Icon(
                Icons.logout,
                size: 30,
              ),
              title: Text(
                'Log out',
                style: R.styles.fz16,
              ),
              onTap: () {
                clinicProvider.logout(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
