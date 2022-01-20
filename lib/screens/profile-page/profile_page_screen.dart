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
import 'package:provider/provider.dart';

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
                  subtitle: Text('view/edit profile'),
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
                  subtitle: Text('view/edit notice'),
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
                  subtitle: Text('view subscription and plans'),
                ),
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
