import 'package:booktokenclinicapp/constants/globals.dart';
import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/models/clinic_token_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/clinic/widgets/token_widget.dart';
import 'package:booktokenclinicapp/widgets/textfield_borders.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ClinicTokenView extends StatefulWidget {
  final Clinic clinic;
  const ClinicTokenView({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicTokenViewState createState() => _ClinicTokenViewState();
}

class _ClinicTokenViewState extends State<ClinicTokenView> {
  late Clinic clinic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;

    print('inititialted');
    if (clinic.hasClinicStarted) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => Provider.of<ClinicProvider>(context, listen: false).getPendingTokens());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          // horizontal: MediaQuery.of(context).size.width * 0.025,
          ),
      child: ChangeNotifierProvider.value(
        value: clinic,
        child: Consumer2<Clinic, ClinicProvider>(
          builder: (context, clinic, clinicProvider, _) {
            // String buttonText = '';
            // TokenActionButtonState buttonState = TokenActionButtonState.LOADING;

            // if (clinicProvider.isLoadingTokens) {
            //   print('Loading');
            //   buttonText = 'Loading..';
            //   buttonState = TokenActionButtonState.LOADING;
            // } else {
            //   if (clinicProvider.hasErrorUserTokenLoading) {
            //     buttonText = 'Retry';
            //     buttonState = TokenActionButtonState.ERROR;

            //     print('Retry');
            //   } else {
            //     if (clinicProvider.userTokenList.isEmpty) {
            //       buttonText = "Request";
            //       buttonState = TokenActionButtonState.REQUEST;

            //       print('Request');
            //     } else {
            //       if (clinicProvider.userTokenList[0].tokenStatus == TokenStatus.REQUESTED) {
            //         if (clinicProvider.userTokenList[0].clinic.id == clinic.id) {
            //           buttonText = "Cancel My Request";
            //           buttonState = TokenActionButtonState.CANCEL_REQUEST;

            //           print('Cancel Request');
            //         } else {
            //           buttonText = "You already have a token requested";
            //           buttonState = TokenActionButtonState.NAVIGATE;

            //           print('you already have a token requested');
            //         }
            //       }
            //       if (clinicProvider.userTokenList[0].tokenStatus == TokenStatus.PENDING_TOKEN) {
            //         if (clinicProvider.userTokenList[0].clinic.id == clinic.id) {
            //           buttonText = "Cancel My token";
            //           buttonState = TokenActionButtonState.CANCEL_TOKEN;

            //           print('Cancel token');
            //         } else {
            //           buttonText = "You already have a token pending";
            //           buttonState = TokenActionButtonState.NAVIGATE;

            //           print('you already have a token requested');
            //         }
            //       }
            //     }
            //   }
            // }

            return Container(
              child: !clinic.hasClinicStarted
                  ? Center(child: Text('Closed'))
                  : clinicProvider.isLoadingTokens
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  child: Wrap(children: [
                                    for (int i = 0; i < clinicProvider.clinicPendingTokenList.length; i++)
                                      TokenWidget(clinicToken: clinicProvider.clinicPendingTokenList[i], index: i)
                                  ]),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                                  onPressed: () async {
                                    // ServiceResponse serviceResponse = await clinicProvider.getUserToken();

                                    // if (serviceResponse.apiResponse.error) {
                                    //   Fluttertoast.showToast(
                                    //       msg: 'something went wrong...try again!',
                                    //       toastLength: Toast.LENGTH_SHORT,
                                    //       gravity: ToastGravity.BOTTOM,
                                    //       timeInSecForIosWeb: 2,
                                    //       fontSize: 16.0);

                                    //   return;
                                    // }
                                    // List<ClinicToken> data = serviceResponse.data.toList();

                                    // if (buttonState == TokenActionButtonState.REQUEST) {
                                    //   print('here1');

                                    //   await requestToken(clinicProvider: clinicProvider, clinic: clinic);
                                    //   return;
                                    // }
                                    // if (buttonState == TokenActionButtonState.CANCEL_REQUEST) {
                                    //   print('here2');

                                    //   // if (serviceResponse.data.isNotEmpty && serviceResponse.data.first.tokenStatus == TokenStatus.REQUESTED) {
                                    //   if (data.isNotEmpty && data.first.tokenStatus == TokenStatus.REQUESTED) {
                                    //     await cancelRequest(clinicProvider: clinicProvider, clinic: clinic, token: data.first);
                                    //   }

                                    //   return;
                                    // }
                                    // if (buttonState == TokenActionButtonState.CANCEL_TOKEN) {
                                    //   print('here3');

                                    //   if (data.isNotEmpty && data.first.tokenStatus == TokenStatus.PENDING_TOKEN) {
                                    //     await cancelToken(clinicProvider: clinicProvider, clinic: clinic, token: data.first);
                                    //     await clinic.getPendingTokens();
                                    //   }
                                    //   return;
                                    // }
                                    // if (buttonState == TokenActionButtonState.ERROR) {
                                    //   // print('here4');

                                    //   // await requestToken(clinicProvider: clinicProvider, clinic: clinic);
                                    //   // return;
                                    // }
                                    // if (buttonState == TokenActionButtonState.NAVIGATE) {
                                    //   print('here5');
                                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ClinicUserToken(showAppbar: false)));

                                    //   return;
                                    // }

                                    Map<String, dynamic>? result = await _showBottomSheet();
                                    print(result.toString());
                                    if (result != null && result['proceed']) {
                                      ServiceResponse serviceResponse = await clinicProvider.addOfflineToken(result['name']);

                                      if (serviceResponse.apiResponse.error) {
                                        Fluttertoast.showToast(
                                            msg: serviceResponse.apiResponse.errMsg,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 2,
                                            fontSize: 16.0);

                                        return;
                                      }
                                      await clinicProvider.getPendingTokens();
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
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 30),
                Text('Enter Name of Patient (optional)'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  child: TextFormField(
                    decoration: InputDecoration(border: formBorder),
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
                    TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                        onPressed: () {
                          Navigator.of(context).pop({'proceed': true, 'name': name});
                        },
                        child: Text('Proced')),
                    SizedBox(
                      width: 40,
                    ),
                    TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                        onPressed: () {
                          Navigator.of(context).pop({'proceed': false, 'name': name});
                        },
                        child: Text('Cancel')),
                  ],
                )
              ]),
            );
          });
        });
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
