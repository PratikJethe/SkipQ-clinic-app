import 'dart:developer';

import 'package:skipq_clinic/models/api_response_model.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/screens/clinic/clinic_tab_view.dart';
import 'package:skipq_clinic/screens/profile/widget/profile_image.dart';
import 'package:flutter/material.dart';

import 'package:skipq_clinic/models/clinic_token_model.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RequestTokenWidget extends StatefulWidget {
  final ClinicToken clinicToken;
  final int index;
  const RequestTokenWidget({Key? key, required this.clinicToken, required this.index}) : super(key: key);

  @override
  _RequestTokenWidgetState createState() => _RequestTokenWidgetState();
}

class _RequestTokenWidgetState extends State<RequestTokenWidget> {
  late ClinicToken clinicToken;
  late int index;
  @override
  void initState() {
    super.initState();
    clinicToken = widget.clinicToken;
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Color.fromRGBO(112, 144, 176, 0.15),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            // border:
            //     (clinicToken.user != null && clinicToken.user!.id == userProvider.user.id) ? Border.all(color: R.color.primaryL1, width: 4) : null,
            // color: Color.fromRGBO(224, 227, 231, 0.3),
            borderRadius: BorderRadius.circular(0)),
        width: (MediaQuery.of(context).size.width * 0.95),
        child: Container(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: UserProfileWidget(
                    height: 90,
                    width: 90,
                    shape: BoxShape.circle,
                    url: clinicToken.user?.profilePicUrl,
                  ),
                  // child: Container(
                  //   clipBehavior: Clip.hardEdge,
                  //   decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                  //   height: 90,
                  //   width: 90,
                  //   child: (clinicToken.user != null && clinicToken.isOnline)
                  //       ? Image.network(
                  //           clinicToken.user!.profilePicUrl ?? 'https://www.pngarts.com/files/3/Avatar-Free-PNG-Image.png',
                  //           fit: BoxFit.cover,
                  //         )
                  //       : Image.network('https://www.pngarts.com/files/3/Avatar-Free-PNG-Image.png'),
                  // ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${clinicToken.user!.fullName}',
                          style: R.styles.fz18Fw500,
                          maxLines: 2,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0), side: BorderSide.none)),
                                      backgroundColor: MaterialStateProperty.all(
                                        R.color.primaryL1,
                                      ),
                                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                                      visualDensity: VisualDensity(vertical: 0, horizontal: 0)),
                                  onPressed: () async {
                                    print(clinicToken.user!.fullName);
                                    ClinicProvider clinicProvider = Provider.of<ClinicProvider>(context, listen: false);
                                    clinicProvider.setShowModalLoading = true;
                                    ServiceResponse serviceResponse = await clinicProvider.acceptRequest(clinicToken.id);

                                    if (serviceResponse.apiResponse.error) {
                                      clinicProvider.setShowModalLoading = false;

                                      print(serviceResponse.apiResponse.error);
                                      Fluttertoast.showToast(
                                          msg: serviceResponse.apiResponse.errMsg,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 16.0);
                                      return;
                                    }

                                    await clinicProvider.getRequests(showLoading: true);
                                    await clinicProvider.getPendingTokens();
                                    clinicProvider.setShowModalLoading = false;
                                  },
                                  child: Text(
                                    'Accept',
                                    style: R.styles.fontColorWhite,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      print(clinicToken.user!.fullName);

                                      showAlertBoxTokenAction('Are you sure you want to Decline this request?', 'Reject', () async {
                                        ClinicProvider clinicProvider = Provider.of<ClinicProvider>(context, listen: false);
                                        clinicProvider.setShowModalLoading = true;

                                        ServiceResponse serviceResponse = await clinicProvider.rejectRequest(clinicToken.id);
                                        if (serviceResponse.apiResponse.error) {
                                          clinicProvider.setShowModalLoading = false;

                                          Fluttertoast.showToast(
                                              msg: serviceResponse.apiResponse.errMsg,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 2,
                                              fontSize: 16.0);
                                          return;
                                        }

                                        await clinicProvider.getRequests();
                                        await clinicProvider.getPendingTokens();
                                        clinicProvider.setShowModalLoading = false;
                                      }, context);
                                    },
                                    child: Text(
                                      'Decline',
                                      style: R.styles.fontColorPrimary,
                                    ),
                                    style: OutlinedButton.styleFrom(side: BorderSide(color: R.color.primary)
                                        // shape: MaterialStateProperty.all(
                                        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0), side: BorderSide.none)),
                                        // backgroundColor: MaterialStateProperty.all(R.color.white)),
                                        ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
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
