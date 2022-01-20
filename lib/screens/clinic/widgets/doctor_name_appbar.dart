import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class DoctorNameAppbar extends StatefulWidget {
  final Clinic clinic;
  final Function onClick;

  const DoctorNameAppbar({Key? key, required this.clinic, required this.onClick}) : super(key: key);

  @override
  _DoctorNameAppbarState createState() => _DoctorNameAppbarState();
}

class _DoctorNameAppbarState extends State<DoctorNameAppbar> {
  late Clinic clinic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // clinic = widget.clinic;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
      clinic = clinicProvider.clinic;
      return Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'hello,',
                  style: R.styles.fz16Fw500.merge(R.styles.fontColorGrey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Dr. ${clinic.doctorName}',
                  style: R.styles.fz20Fw500,
                ),
              ],
            ),
            Spacer(),
            clinic.hasClinicStarted
                ? SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(R.color.primary),
                      ),
                      onPressed: () async {
                        clinicProvider.setShowModalLoading = true;

                        ServiceResponse serviceResponse = await clinicProvider.stopClinic();
                        clinicProvider.setShowModalLoading = false;

                        if (serviceResponse.apiResponse.error) {
                          Fluttertoast.showToast(
                              msg: serviceResponse.apiResponse.errMsg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              fontSize: 16.0);
                        }
                      },
                      child: Text(
                        'Close Clinic',
                        style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                      ),
                    ))
                : SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(R.color.primary),
                      ),
                      onPressed: () async {
                        clinicProvider.setShowModalLoading = true;
                        ServiceResponse serviceResponse = await clinicProvider.startCilnic();
                        clinicProvider.setShowModalLoading = false;

                        if (serviceResponse.apiResponse.error) {
                          Fluttertoast.showToast(
                              msg: serviceResponse.apiResponse.errMsg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              fontSize: 16.0);
                        }
                      },
                      child: Text(
                        'Open Clinic',
                        style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                      ),
                    ))
            // IconButton(
            //   iconSize: 36,
            //   padding: EdgeInsets.zero,
            //   constraints: BoxConstraints(),
            //   onPressed: () {
            //     widget.onClick();
            //   },
            //   icon: Icon(
            //     Icons.menu,
            //   ),
            // )
          ],
        ),
      );
    });
  }
}
