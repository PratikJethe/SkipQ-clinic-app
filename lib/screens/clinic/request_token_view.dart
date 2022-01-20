import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/screens/clinic/tab_views/request_view.dart';
import 'package:booktokenclinicapp/screens/clinic/tab_views/token_view.dart';

import 'package:booktokenclinicapp/screens/clinic/widgets/doctor_name_appbar.dart';
import 'package:booktokenclinicapp/screens/drawer/clinic_drawer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestTokenView extends StatefulWidget {
  const RequestTokenView({Key? key}) : super(key: key);

  @override
  _RequestTokenViewState createState() => _RequestTokenViewState();
}

class _RequestTokenViewState extends State<RequestTokenView> {
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
                        child: CllinicRequestView(
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
