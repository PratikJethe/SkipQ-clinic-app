import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/clinic/widgets/clinic_info_card.dart';
import 'package:booktokenclinicapp/screens/clinic/widgets/clinic_info_widget.dart';
import 'package:booktokenclinicapp/screens/clinic/clinic_tab_view.dart';
import 'package:booktokenclinicapp/screens/homepage/widget/bottom_navigation_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ClinicProvider>(
          builder: (context, clinicProvider, _) {
            clinic = clinicProvider.clinic;
            print(clinicProvider.clinic.gender);
            return Container(
              // height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    // color: Colors.amber,
                    width: double.infinity,
                    height: 60,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'My Clinic',
                          style: R.styles.fz16FontColorPrimary.merge(R.styles.fz24Fw500),
                        )),
                  ),
                  ClinicInfoWidget(clinic: clinic),
                  Expanded(child: ClinicTabView(clinic: clinic))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
