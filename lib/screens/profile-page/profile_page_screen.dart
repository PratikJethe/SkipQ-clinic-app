import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/clinic/tab_views/request_view.dart';
import 'package:booktokenclinicapp/screens/clinic/widgets/doctor_name_appbar.dart';
import 'package:booktokenclinicapp/screens/my-subscriptions/subscription_page.dart';
import 'package:booktokenclinicapp/screens/notice/notice_screen.dart';
import 'package:booktokenclinicapp/screens/profile/profile_screen.dart';
import 'package:booktokenclinicapp/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Clinic clinic;

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
                        recipients: ['booktokenhelp@gmail.com'],
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
                          'check out this app which helps you to manage your clinic tokens online and helps patients to save time and efforts \n https://play.google.com/store/apps/details?id=com.company.booktoken');
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
