import 'dart:ffi';

import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';

import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/screens/clinic/tab_views/about_clinic.dart';
import 'package:booktokenclinicapp/screens/clinic/tab_views/request_view.dart';
import 'package:booktokenclinicapp/screens/clinic/tab_views/token_view.dart';
import 'package:flutter/material.dart';

class ClinicTabView extends StatefulWidget {
  final Clinic clinic;

  const ClinicTabView({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicTabViewState createState() => _ClinicTabViewState();
}

class _ClinicTabViewState extends State<ClinicTabView> with TickerProviderStateMixin {
  late TabController _tabController;

  late Clinic clinic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      elevation: 25,
      shadowColor: Color.fromRGBO(112, 144, 176, 0.70),
      child: Container(
        width: double.infinity,
        // color: Colors.red,
        child: Center(
          child: Container(
            // color: Colors.amber,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
                  // width: MediaQuery.of(context).size.width * 0.9,
                  height: 45,
                  child: TabBar(
                      padding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      indicator: BoxDecoration(color: R.color.primary, borderRadius: BorderRadius.circular(5)),
                      indicatorColor: Colors.transparent,
                      labelColor: R.color.white,
                      labelStyle: R.styles.fz16Fw500,
                      unselectedLabelColor: R.color.black,
                      controller: _tabController,
                      tabs: [
                        Tab(text: "Token"),
                        Tab(text: "Request"),
                        Tab(text: "About"),
                      ]),
                ),
                Expanded(
                  child: Container(
                    //Add this to give height
                    child: TabBarView(controller: _tabController, children: [
                      ClinicTokenView(
                        clinic: clinic,
                      ),
                      // Expanded(
                      //   child: Container(
                      //     child: Text("Token View"),
                      //   ),
                      // ),
                      Container(
                        child: CllinicRequestView(clinic: clinic),
                      ),
                      AboutClinic(
                        clinic: clinic,
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showAlertBoxTokenAction(String title, String buttontText, Function callback, BuildContext context) {
  print('alert dialog');
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            actions: [
              TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                  onPressed: () {
                    callback();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    buttontText,
                    style: R.styles.fontColorWhite,
                  )),
              TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'))
            ],
          ));
}
