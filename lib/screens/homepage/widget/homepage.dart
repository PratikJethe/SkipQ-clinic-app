import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/clinic/tab_views/token_view.dart';
import 'package:booktokenclinicapp/screens/clinic/widgets/clinic_info_card.dart';
import 'package:booktokenclinicapp/screens/clinic/widgets/clinic_info_widget.dart';
import 'package:booktokenclinicapp/screens/clinic/clinic_tab_view.dart';
import 'package:booktokenclinicapp/screens/clinic/widgets/doctor_name_appbar.dart';
import 'package:booktokenclinicapp/screens/drawer/clinic_drawer.dart';
import 'package:booktokenclinicapp/screens/homepage/widget/bottom_navigation_bar.dart';
import 'package:booktokenclinicapp/screens/profile/widget/profile_image.dart';
import 'package:booktokenclinicapp/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late Clinic clinic;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        // drawer: ClinicDrawer(),
        body: Consumer<ClinicProvider>(
          builder: (context, clinicProvider, _) {
            clinic = clinicProvider.clinic;
            print(clinicProvider.clinic.gender);
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DoctorNameAppbar(
                      clinic: clinic,
                      onClick: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                    ),

                    Expanded(
                        child: ClinicTokenView(
                      clinic: clinic,
                    ))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
