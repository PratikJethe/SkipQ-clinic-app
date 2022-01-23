import 'dart:async';

import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/clinic/widgets/request_token_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CllinicRequestView extends StatefulWidget {
  final Clinic clinic;
  const CllinicRequestView({Key? key, required this.clinic}) : super(key: key);

  @override
  _CllinicRequestViewState createState() => _CllinicRequestViewState();
}

class _CllinicRequestViewState extends State<CllinicRequestView> {
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('inititialted');
    if (Provider.of<ClinicProvider>(context, listen: false).clinic.hasClinicStarted) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => Provider.of<ClinicProvider>(context, listen: false).getRequests(showLoading: true));
    }

    timer = Timer.periodic(Duration(seconds: 120), (timer) {
      if (Provider.of<ClinicProvider>(context, listen: false).clinic.hasClinicStarted) {
        print('calling');
        Provider.of<ClinicProvider>(context, listen: false).getRequests();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(
          // horizontal: MediaQuery.of(context).size.width * 0.025,
          ),
      child: Consumer<ClinicProvider>(
        builder: (context, clinicProvider, _) {
          return Container(
            child: !clinicProvider.clinic.hasClinicStarted
                ? Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Your Clinic Is Closed',
                      style: R.styles.fontColorGrey.merge(R.styles.fz16Fw500),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(R.color.primary),
                          ),
                          onPressed: () async {
                            ServiceResponse serviceResponse = await clinicProvider.logout(context);

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
                            'LogOut',
                            style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                          ),
                        ))
                  ]))
                : clinicProvider.isLoadingRequest
                    ? Center(
                        child: CircularProgressIndicator(
                          color: R.color.primaryL1,
                        ),
                      )
                    : clinicProvider.hasRequestError
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Something Went Wrong!..Try again',
                                  style: R.styles.fz18Fw500,
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(R.color.primary),
                                      ),
                                      onPressed: () async {
                                        clinicProvider.getRequests(showLoading: true);
                                      },
                                      child: Text(
                                        'Retry',
                                        style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                                      ),
                                    ))
                              ],
                            ),
                          )
                        : clinicProvider.clinicRequestedTokenList.length == 0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No Pending Requests',
                                      style: R.styles.fz18Fw500,
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                        height: 40,
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(R.color.primary),
                                          ),
                                          onPressed: () async {
                                          await  clinicProvider.getRequests(showLoading: true);
                                          },
                                          child: Text(
                                            'Reload',
                                            style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                                          ),
                                        ))
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text('Pending Request:',style: R.styles.fz18Fw500,),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('${clinicProvider.clinicRequestedTokenList.length}',style: R.styles.fz20Fw500.merge(R.styles.fontColorPrimaryL1),),
                                      ],
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          await clinicProvider.getRequests();
                                        },
                                        // child: SingleChildScrollView(
                                        //   physics: AlwaysScrollableScrollPhysics(),
                                        // child: Container(
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              RequestTokenWidget(clinicToken: clinicProvider.clinicRequestedTokenList[index], index: index),
                                          itemCount: clinicProvider.clinicRequestedTokenList.length,
                                          //   children: [
                                          //   for (int i = 0; i < clinicProvider.clinicRequestedTokenList.length; i++)
                                          //     RequestTokenWidget(clinicToken: clinicProvider.clinicRequestedTokenList[i], index: i)
                                          // ]
                                        ),
                                        // ),
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
          );
        },
      ),
    );
  }
}


// requestToken({
//   required ClinicProvider clinicProvider,
//   required Clinic clinic,
// }) async {
//   ServiceResponse response = await clinic.requestToken();

//   if (response.apiResponse.error) {
//     Fluttertoast.showToast(
//       msg: response.apiResponse.errMsg,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 2,
//       fontSize: 16.0,
//     );
//     return;
//   }

//   await clinicProvider.getUserToken();
//   Fluttertoast.showToast(
//     msg: 'Request sent succesfully',
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 2,
//     fontSize: 16.0,
//   );
// }

// cancelRequest({required ClinicProvider clinicProvider, required Clinic clinic, required ClinicToken token}) async {
//   ServiceResponse response = await clinic.cancelRequest(token.id);

//   if (response.apiResponse.error) {
//     Fluttertoast.showToast(
//       msg: response.apiResponse.errMsg,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 2,
//       fontSize: 16.0,
//     );
//     return;
//   }

//   await clinicProvider.getUserToken();
//   Fluttertoast.showToast(
//     msg: 'Token request cancelled',
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 2,
//     fontSize: 16.0,
//   );
// }

// cancelToken({required ClinicProvider clinicProvider, required Clinic clinic, required ClinicToken token}) async {
//   ServiceResponse response = await clinic.cancelToken(token.id);

//   if (response.apiResponse.error) {
//     Fluttertoast.showToast(
//       msg: response.apiResponse.errMsg,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 2,
//       fontSize: 16.0,
//     );
//     return;
//   }

//   await clinicProvider.getUserToken();
//   Fluttertoast.showToast(
//     msg: 'Token request cancelled',
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 2,
//     fontSize: 16.0,
//   );
// }
