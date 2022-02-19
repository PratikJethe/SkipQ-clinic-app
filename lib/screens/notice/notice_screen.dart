import 'package:skipq_clinic/models/api_response_model.dart';
import 'package:skipq_clinic/models/clinic_model.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:skipq_clinic/screens/modal-screen/modal_loading_screen.dart';
import 'package:skipq_clinic/widgets/custom_appbars.dart';
import 'package:skipq_clinic/widgets/textfield_borders.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  bool isWriting = false;
  late Clinic clinic;
  String notice = "";
  @override
  Widget build(BuildContext context) {
    return ModalLoadingScreen(
      child: Scaffold(
          floatingActionButton: !isWriting
              ? FloatingActionButton(
                  backgroundColor: R.color.primaryL1,
                  onPressed: () {
                    setState(() {
                      isWriting = true;
                    });
                  },
                  child: Icon(Icons.edit),
                )
              : null,
          appBar: backArrowAppbarWithTitle(context, 'Notice'),
          body: SingleChildScrollView(
            child: Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
              clinic = clinicProvider.clinic;
              return isWriting
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    notice = value.trim();
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: formBorder,
                                  focusedBorder: formBorder,
                                ),
                                initialValue: clinicProvider.clinic.notice,
                                // minLines: 1,
                                maxLines: 10,
                                // expands: true,
                                maxLength: 300,
                              )),
                          SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(R.color.primary),
                                ),
                                onPressed: () async {
                                  Map<String, dynamic> payload = {
                                    "doctorName": clinic.doctorName.trim(),
                                    "clinicName": clinic.clinicName.trim(),
                                    "pincode": clinic.address.pincode == null || clinic.address.pincode!.isEmpty ? null : clinic.address.pincode,
                                    "address": clinic.address.address.trim(),
                                    "apartment":
                                        clinic.address.apartment == null || clinic.address.apartment!.isEmpty ? null : clinic.address.apartment,
                                    "gender": clinic.gender == null ? null : clinic.gender.toString().split('.').last,
                                    "city": clinic.address.city.isEmpty ? null : clinic.address.city,
                                    "speciality": clinic.speciality,
                                    "dateOfBirth": clinic.dob?.toIso8601String(),
                                    "coordinates": clinic.address.coordinates,
                                    "profilePicUrl": clinic.profilePicUrl,
                                    "notice": notice
                                  };
                                  print(payload);
                                  payload.removeWhere((key, value) => value == null || value == '');
                                  clinicProvider.setShowModalLoading = true;

                                  ServiceResponse serviceResponse = await clinicProvider.updateClinic(payload);

                                  if (serviceResponse.apiResponse.error) {
                                    clinicProvider.setShowModalLoading = false;

                                    Fluttertoast.showToast(
                                        msg: "${serviceResponse.apiResponse.errMsg}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 2,
                                        fontSize: 16.0);
                                  } else {
                                    clinicProvider.setShowModalLoading = false;
                                    setState(() {
                                      isWriting = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Notice updated succesfully!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 2,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Text(
                                  'Update Notice',
                                  style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                                ),
                              ))
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.width * 0.4,
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        // margin: EdgeInsets.all(10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: R.color.primaryL1),
                        child: Text(
                          clinicProvider.clinic.notice == null || clinicProvider.clinic.notice!.isEmpty
                              ? 'No Notice'
                              : clinicProvider.clinic.notice!,
                          style: R.styles.fz16Fw500.merge(R.styles.fontColorWhite),
                        ),
                      ),
                    );
            }),
          )),
    );
  }
}
