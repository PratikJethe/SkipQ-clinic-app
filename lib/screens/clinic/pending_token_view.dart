import 'package:skipq_clinic/models/clinic_model.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/screens/clinic/tab_views/token_view.dart';

import 'package:skipq_clinic/screens/clinic/widgets/doctor_name_appbar.dart';
import 'package:skipq_clinic/screens/drawer/clinic_drawer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingTokenView extends StatefulWidget {
  const PendingTokenView({Key? key}) : super(key: key);

  @override
  _PendingTokenViewState createState() => _PendingTokenViewState();
}

class _PendingTokenViewState extends State<PendingTokenView> {
  late Clinic clinic;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        drawer: ClinicDrawer(),
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
