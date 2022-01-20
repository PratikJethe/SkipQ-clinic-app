import 'package:booktokenclinicapp/constants/globals.dart';
import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/clinic_token_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/clinic/clinic_tab_view.dart';
import 'package:booktokenclinicapp/screens/profile/profile_screen.dart';
import 'package:booktokenclinicapp/screens/profile/widget/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PendingTokenWidget extends StatefulWidget {
  final ClinicToken clinicToken;
  final int index;
  const PendingTokenWidget({Key? key, required this.clinicToken, required this.index}) : super(key: key);

  @override
  _PendingTokenWidgetState createState() => _PendingTokenWidgetState();
}

class _PendingTokenWidgetState extends State<PendingTokenWidget> {
  late ClinicToken clinicToken;
  late int index;
  @override
  void initState() {
    super.initState();
    clinicToken = widget.clinicToken;
    index = widget.index;
    // print('Token');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
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
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Token ', style: R.styles.fz18Fw700),
                              TextSpan(text: '#${clinicToken.tokenNumber}', style: R.styles.fz18Fw700.merge(R.styles.fontColorPrimary)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '${ clinicToken.isOnline? clinicToken.user!.fullName : clinicToken.userName??'No Name'}',
                          style: R.styles.fz16Fw700,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${clinicToken.isOnline ? 'Online' : 'In clinic'}',
                          style: R.styles.fz16Fw700.merge(R.styles.fontColorBluishGrey),
                          maxLines: 1,
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
                                    ClinicProvider clinicProvider = Provider.of<ClinicProvider>(context, listen: false);
                                    clinicProvider.setShowModalLoading = true;

                                    ServiceResponse serviceResponse =
                                        await clinicProvider.completeToken(clinicToken.id);
                                    if (serviceResponse.apiResponse.error) {
                                      Fluttertoast.showToast(
                                          msg: serviceResponse.apiResponse.errMsg,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 16.0);
                                     clinicProvider.setShowModalLoading = false;

                                      return;
                                    }

                                    await clinicProvider.getPendingTokens(showLoading: true);
                                   clinicProvider.setShowModalLoading = false;
                                  },
                                  child: Text(
                                    'Done',
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
                                      print(clinicToken.tokenStatus);
                                      showAlertBoxTokenAction('Are you sure you want to Discard this token?', 'Discard', () async {
                                                                            ClinicProvider clinicProvider = Provider.of<ClinicProvider>(context, listen: false);

                                        clinicProvider.setShowModalLoading = true;

                                        ServiceResponse serviceResponse =
                                            await clinicProvider.discardToken(clinicToken.id);
                                        if (serviceResponse.apiResponse.error) {
                                          Fluttertoast.showToast(
                                              msg: serviceResponse.apiResponse.errMsg,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 2,
                                              fontSize: 16.0);
                                          clinicProvider.setShowModalLoading = false;

                                          return;
                                        }

                                        await clinicProvider.getPendingTokens(showLoading: true);
                                        clinicProvider.setShowModalLoading = false;
                                      }, context);
                                    },
                                    child: Text(
                                      'Discard',
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

  //   Card(
  //     elevation: 0,
  //     shadowColor: Color.fromRGBO(112, 144, 176, 0.15),
  //     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //     child: Container(
  //       clipBehavior: Clip.hardEdge,
  //       decoration: BoxDecoration(
  //           // border:
  //           //     (clinicToken.user != null && clinicToken.user!.id == userProvider.user.id) ? Border.all(color: R.color.primaryL1, width: 4) : null,
  //           color: Color.fromRGBO(224, 227, 231, 0.3),
  //           borderRadius: BorderRadius.circular(0)),
  //       width: (MediaQuery.of(context).size.width * 0.95),
  //       height: MediaQuery.of(context).size.height * 0.23,
  //       child: Container(
  //         // height: MediaQuery.of(context).size.height * 0.4,
  //         // width: (MediaQuery.of(context).size.width * 0.90) / 2 - 10,
  //         child: Container(
  //           margin: EdgeInsets.symmetric(vertical: 15),
  //           child: Row(
  //             children: [
  //               UserProfileWidget(
  //                 url: clinicToken.user?.profilePicUrl,
  //                 width: 60,
  //                 height: 100,
  //               ),
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 // mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Expanded(
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             mainAxisSize: MainAxisSize.max,
  //                             children: [
  //                               Text(
  //                                 'Token Number: ${index + 1}',
  //                                 style: R.styles.fz14Fw500,
  //                               ),
  //                               SizedBox(height: 2),
  //                               Text(
  //                                 'Patinet:${clinicToken.isOnline ? 'Online' : 'Offline'}',
  //                                 style: R.styles.fz14Fw500,
  //                               ),
  //                               SizedBox(height: 2),
  //                               Text(
  //                                 'Name: ${clinicToken.isOnline ? '${clinicToken.user?.fullName ?? 'No Name'}' : '${clinicToken.userName ?? 'No Name'}'}' *
  //                                     200,
  //                                 style: R.styles.fz14Fw500,
  //                                 maxLines: 2,
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
  //                     height: MediaQuery.of(context).size.height * 0.07,
  //                     child: Row(
  //                       children: [
  //                         if (index == 0)
  //                           Expanded(
  //                             child: TextButton(
  //                               style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                     R.color.primaryL1,
  //                                   ),
  //                                   padding: MaterialStateProperty.all(EdgeInsets.zero),
  //                                   visualDensity: VisualDensity(vertical: 0, horizontal: 0)),
  //                               onPressed: () async {
  //                                 ServiceResponse serviceResponse = await Provider.of<ClinicProvider>(context, listen: false).completeToken(clinicToken.id);
  //                                 ClinicProvider clinicProvider = Provider.of<ClinicProvider>(context, listen: false);
  //                                 if (serviceResponse.apiResponse.error) {
  //                                   Fluttertoast.showToast(
  //                                       msg: serviceResponse.apiResponse.errMsg,
  //                                       toastLength: Toast.LENGTH_SHORT,
  //                                       gravity: ToastGravity.BOTTOM,
  //                                       timeInSecForIosWeb: 2,
  //                                       fontSize: 16.0);
  //                                   return;
  //                                 }

  //                                 await clinicProvider.getPendingTokens();
  //                               },
  //                               child: Text(
  //                                 'Done',
  //                                 style: R.styles.fontColorWhite,
  //                               ),
  //                             ),
  //                           ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         Expanded(
  //                           child: TextButton(
  //                             onPressed: () {
  //                               print(clinicToken.tokenStatus);
  //                               showAlertBoxTokenAction('Are you sure you want to Discard this token?', 'Discard', () async {
  //                                 ServiceResponse serviceResponse = await Provider.of<ClinicProvider>(context, listen: false).discardToken(clinicToken.id);
  //                                 ClinicProvider clinicProvider = Provider.of<ClinicProvider>(context, listen: false);
  //                                 if (serviceResponse.apiResponse.error) {
  //                                   Fluttertoast.showToast(
  //                                       msg: serviceResponse.apiResponse.errMsg,
  //                                       toastLength: Toast.LENGTH_SHORT,
  //                                       gravity: ToastGravity.BOTTOM,
  //                                       timeInSecForIosWeb: 2,
  //                                       fontSize: 16.0);
  //                                   return;
  //                                 }

  //                                 await clinicProvider.getPendingTokens();
  //                               }, context);
  //                             },
  //                             child: Text(
  //                               'Discard',
  //                               style: R.styles.fontColorWhite,
  //                             ),
  //                             style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primaryL1)),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _showModlaSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [],
            ),
          );
        });
  }
}
