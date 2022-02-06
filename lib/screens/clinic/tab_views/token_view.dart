import 'dart:async';

import 'package:skipq_clinic/constants/globals.dart';
import 'package:skipq_clinic/models/api_response_model.dart';
import 'package:skipq_clinic/models/clinic_model.dart';
import 'package:skipq_clinic/models/clinic_token_model.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:skipq_clinic/screens/clinic/widgets/pending_token_widget.dart';
import 'package:skipq_clinic/screens/clinic/widgets/token_widget.dart';
import 'package:skipq_clinic/widgets/textfield_borders.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ClinicTokenView extends StatefulWidget {
  final Clinic clinic;
  const ClinicTokenView({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicTokenViewState createState() => _ClinicTokenViewState();
}

class _ClinicTokenViewState extends State<ClinicTokenView> with AutomaticKeepAliveClientMixin {
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // clinic = widget.clinic;

    print('inititialted');

    if (Provider.of<ClinicProvider>(context, listen: false).clinic.hasClinicStarted) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => Provider.of<ClinicProvider>(context, listen: false).getPendingTokens(showLoading: true));
    }

    timer = Timer.periodic(Duration(seconds: 120), (timer) {
      if (Provider.of<ClinicProvider>(context, listen: false).clinic.hasClinicStarted) {
        print('calling');
        Provider.of<ClinicProvider>(context, listen: false).getPendingTokens();
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
                    // SizedBox(
                    //     height: 40,
                    //     width: MediaQuery.of(context).size.width * 0.2,
                    //     child: TextButton(
                    //       style: ButtonStyle(
                    //         backgroundColor: MaterialStateProperty.all(R.color.primary),
                    //       ),
                    //       onPressed: () async {
                    //         clinicProvider.setShowModalLoading = true;
                    //         ServiceResponse serviceResponse = await clinicProvider.startCilnic();
                    //         clinicProvider.setShowModalLoading = false;

                    //         if (serviceResponse.apiResponse.error) {
                    //           Fluttertoast.showToast(
                    //               msg: serviceResponse.apiResponse.errMsg,
                    //               toastLength: Toast.LENGTH_SHORT,
                    //               gravity: ToastGravity.BOTTOM,
                    //               timeInSecForIosWeb: 2,
                    //               fontSize: 16.0);
                    //         }
                    //       },
                    //       child: Text(
                    //         'Open',
                    //         style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                    //       ),
                    //     ))
                  ]))
                : clinicProvider.isLoadingTokens
                    ? Center(
                        child: CircularProgressIndicator(
                          color: R.color.primaryL1,
                        ),
                      )
                    : clinicProvider.hasTokenError
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
                                        clinicProvider.getPendingTokens(showLoading: true);
                                      },
                                      child: Text(
                                        'Retry',
                                        style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                                      ),
                                    ))
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: clinicProvider.clinicPendingTokenList.length == 0
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'No Pending Tokens',
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
                                                    await clinicProvider.getPendingTokens(showLoading: true);
                                                  },
                                                  child: Text(
                                                    'Reload',
                                                    style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () async {
                                          await clinicProvider.getPendingTokens();
                                        },
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              PendingTokenWidget(clinicToken: clinicProvider.clinicPendingTokenList[index], index: index),
                                          itemCount: clinicProvider.clinicPendingTokenList.length,
                                          //   children: [
                                          //   for (int i = 0; i < clinicProvider.clinicRequestedTokenList.length; i++)
                                          //     RequestTokenWidget(clinicToken: clinicProvider.clinicRequestedTokenList[i], index: i)
                                          // ]
                                        ),
                                      ),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                                    onPressed: () async {
                                      Map<String, dynamic>? result = await _showBottomSheet();
                                      print(result.toString());

                                      if (result != null && result['proceed']) {
                                        Provider.of<ClinicProvider>(context, listen: false).setShowModalLoading = true;
                                        ServiceResponse serviceResponse = await clinicProvider.addOfflineToken(result['name']);

                                        if (serviceResponse.apiResponse.error) {
                                          Provider.of<ClinicProvider>(context, listen: false).setShowModalLoading = false;
                                          Fluttertoast.showToast(
                                              msg: serviceResponse.apiResponse.errMsg,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 2,
                                              fontSize: 16.0);
                                          return;
                                        }
                                        await clinicProvider.getPendingTokens(showLoading: true);
                                        Provider.of<ClinicProvider>(context, listen: false).setShowModalLoading = false;
                                      }
                                      // print(name);
                                    },
                                    child: Text(
                                      'Add Offline Patients',
                                      style: R.styles.fz16Fw700.merge(TextStyle(color: Colors.white)),
                                    ),
                                  ))
                            ],
                          ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _showBottomSheet() async {
    String? name;
    return showModalBottomSheet<Map<String, dynamic>?>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        builder: (cotext) {
          return
              //  Material(
              //   clipBehavior: Clip.hardEdge,
              //   child:
              StatefulBuilder(builder: (context, setState) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 30),
                Text(
                  'Name of Patient (optional)',
                  style: R.styles.fz18Fw500,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    // cursorHeight: 40,
                    cursorColor: R.color.primary,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsetsDirectional.zero,
                      enabledBorder: formBorder,
                      disabledBorder: formBorder,
                      errorBorder: formBorder,
                      focusedBorder: formBorder,
                      border: formBorder,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        name = value;
                      } else {
                        name = null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                          onPressed: () {
                            Navigator.of(context).pop({'proceed': true, 'name': name});
                          },
                          child: Text(
                            'Proceed',
                            style: R.styles.fz18Fw500.merge(R.styles.fontColorWhite),
                          )),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextButton(
                          style: OutlinedButton.styleFrom(side: BorderSide(color: R.color.primary)),
                          onPressed: () {
                            Navigator.of(context).pop({'proceed': false, 'name': name});
                          },
                          child: Text('Cancel', style: R.styles.fz18Fw500.merge(R.styles.fontColorPrimary))),
                    ),
                  ],
                )
              ]),
            );
          });
          // );
        });
  }

  @override
  bool get wantKeepAlive => true;
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
