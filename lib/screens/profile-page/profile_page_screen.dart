import 'package:launch_review/launch_review.dart';
import 'package:skipq_clinic/config/app_config.dart';
import 'package:skipq_clinic/models/clinic_model.dart';
import 'package:skipq_clinic/privarcy/privarcy_policy.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:skipq_clinic/screens/clinic/tab_views/request_view.dart';
import 'package:skipq_clinic/screens/clinic/widgets/doctor_name_appbar.dart';
import 'package:skipq_clinic/screens/my-subscriptions/subscription_page.dart';
import 'package:skipq_clinic/screens/notice/notice_screen.dart';
import 'package:skipq_clinic/screens/profile/profile_screen.dart';
import 'package:skipq_clinic/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Clinic clinic;
  AppConfig _appConfig = getIt.get<AppConfig>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appbarWithTitle(context, 'Profile Settings'),
        backgroundColor: Colors.white,
        body: Consumer<ClinicProvider>(
          builder: (context, clinicProvider, _) {
            clinic = clinicProvider.clinic;
            print(clinicProvider.clinic.gender);
            return Container(
                child: ListView(
              children: [
                Divider(
                  height: 2,
                  thickness: 2,
                  endIndent: 0,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
                  leading: Icon(
                    Icons.account_circle_rounded,
                    size: 40,
                  ),
                  title: Text(
                    'View Profile',
                    style: R.styles.fz16Fw500,
                  ),
                  subtitle: Text('View/Edit profile'),
                ),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoticeScreen()));
                  },
                  leading: Icon(
                    Icons.note_alt_outlined,
                    size: 40,
                  ),
                  title: Text(
                    'Notice',
                    style: R.styles.fz16Fw500,
                  ),
                  subtitle: Text('View/Edit notice'),
                ),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubscriptionPage()));
                  },
                  leading: Icon(
                    Icons.attach_money,
                    size: 40,
                  ),
                  title: Text(
                    'My Subscriptions',
                    style: R.styles.fz16Fw500,
                  ),
                  subtitle: Text('View subscription and plans'),
                ),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                ListTile(
                    onTap: () async {
                      final Email email = Email(
                        recipients: [_appConfig.helpEmail],
                        isHTML: false,
                      );

                      await FlutterEmailSender.send(email);
                    },
                    leading: Icon(
                      Icons.help_outline_rounded,
                      size: 40,
                    ),
                    title: Text(
                      'Help',
                      style: R.styles.fz16Fw500,
                    ),
                    subtitle: Text('Need help? mail us')),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                ListTile(
                    onTap: () {
                      Share.share(
                          'check out this app which helps you to manage your clinic tokens online and helps patients to save time and efforts \n https://play.google.com/store/apps/details?id=${_appConfig.androidAppId}');
                    },
                    leading: Icon(
                      Icons.share,
                      size: 40,
                    ),
                    title: Text(
                      'Share',
                      style: R.styles.fz16Fw500,
                    ),
                    subtitle: Text('Help us to increase our reach')),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                ListTile(
                    onTap: () {
                      LaunchReview.launch(androidAppId: _appConfig.androidAppId);
                    },
                    leading: Icon(
                      Icons.star_rate_sharp,
                      size: 40,
                    ),
                    title: Text(
                      'Rate Us',
                      style: R.styles.fz16Fw500,
                    ),
                    subtitle: Text('Rate us to improve experience')),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivarcyPolicy()));
                    },
                    leading: Icon(
                      Icons.privacy_tip,
                      size: 40,
                    ),
                    title: Text(
                      'Privacy Policy',
                      style: R.styles.fz16Fw500,
                    ),
                    subtitle: Text('View privacy policy')),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                ListTile(
                    onTap: () {
                      clinicProvider.logout(context);
                    },
                    leading: Icon(
                      Icons.logout,
                      size: 40,
                    ),
                    title: Text(
                      'Log Out',
                      style: R.styles.fz16Fw500,
                    ),
                    subtitle: Text('log out from account')),
              ],
            ));
          },
        ),
      ),
    );
  }
}
