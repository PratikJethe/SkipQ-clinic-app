import 'dart:io';
// import 'package:booktokenapp/constants/globals.dart';
// import 'package:booktokenapp/models/api_response_model.dart';
// import 'package:booktokenapp/models/user_model.dart';
// import 'package:booktokenapp/providers/user_provider.dart';
// import 'package:booktokenapp/resources/resources.dart';
// import 'package:booktokenapp/screens/authentication/registration_screen.dart';
// import 'package:booktokenapp/screens/drawer/drawer_widget.dart';
// import 'package:booktokenapp/service/firebase_services/firebase_storage_service.dart';
// import 'package:booktokenapp/service/image_service/image_service.dart';
// import 'package:booktokenapp/widgets/custom_appbars.dart';
import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/authentication/registration_screen.dart';
import 'package:booktokenclinicapp/screens/modal-screen/modal_loading_screen.dart';
import 'package:booktokenclinicapp/screens/profile/widget/profile_image.dart';
import 'package:booktokenclinicapp/service/firebase_services/firebase_storage_service.dart';
import 'package:booktokenclinicapp/service/image_service/image_service.dart';
import 'package:booktokenclinicapp/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum PicType { CAMERA, GALLERY, REMOVE }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String?> _updateProfilePic(ImageSource imageSource, id) async {
    File? image = await ImageService.updateProfilePic(imageSource);

    if (image != null) {
      return await FirebaseStorageService.uploadImage(image, id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalLoadingScreen(
      child: Scaffold(
        key: scaffoldKey,
        appBar: backArrowAppbar(context),
        // drawer: UserDrawer(),
        body: SafeArea(
          child: Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
            // print(clinicProvider.clinic.dob);
            return Center(
              child: Container(
                // margin: EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        // height: MediaQuery.of(context).size.height*0.9,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    PicType? picType = await _showBottomSheet(clinicProvider.clinic.id);
    
                                    print(picType);
    
                                    String? url;
                                    clinicProvider.setShowModalLoading = true;
                                    if (picType == PicType.CAMERA) {
                                      url = await _updateProfilePic(ImageSource.camera, clinicProvider.clinic.id);
    
                                      if (url == null) {
                                        clinicProvider.setShowModalLoading = false;
                                        return;
                                      }
                                    } else if (picType == PicType.GALLERY) {
                                      url = await _updateProfilePic(ImageSource.gallery, clinicProvider.clinic.id);
                                      if (url == null) {
                                        clinicProvider.setShowModalLoading = false;
    
                                        return;
                                      }
                                    } else if (picType == PicType.REMOVE) {
    
                                      url = null;
                                    } else {
                                      clinicProvider.setShowModalLoading = false;
    
                                      return;
                                    }
                                    Clinic clinic = clinicProvider.clinic;
                                    Map<String, dynamic> payload = {
                                      "doctorName": clinic.doctorName,
                                      "pincode": clinic.address.pincode,
                                      "address": clinic.address.address,
                                      "apartment": clinic.address.apartment,
                                      "gender": clinic.gender == null ? null : clinic.gender.toString().split('.').last,
                                      "city": clinic.address.city,
                                      "dateOfBirth": clinic.dob?.toIso8601String(),
                                      "coordinates": clinic.address.coordinates,
                                      "speciality": clinic.speciality,
                                      "clinicName": clinic.clinicName,
                                      "profilePicUrl": url
                                    };
    
                                    print(payload);
    
                                    payload.removeWhere((key, value) => value == null);
                                    ServiceResponse serviceResponse = await clinicProvider.updateClinic(payload);
    
                                    if (!serviceResponse.apiResponse.error) {
                                      Fluttertoast.showToast(
                                          msg: 'Image succesfully updated',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 16.0);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: serviceResponse.apiResponse.errMsg,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 16.0);
                                    }
                                    clinicProvider.setShowModalLoading = false;
                                  } catch (e) {
                                    clinicProvider.setShowModalLoading = false;
    
                                    print(e);
                                    Fluttertoast.showToast(
                                        msg: 'Something went wong. try again!',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 2,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DoctorProfileWidget(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        height: MediaQuery.of(context).size.height * 0.15,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name',
                                              style: R.styles.fz16Fw700,
                                            ),
                                            Text(clinicProvider.clinic.doctorName, style: R.styles.fz16FontColorPrimary)
                                          ],
                                        ),
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                ),
                              ),
                              infoTile('Contact', '+${clinicProvider.clinic.contact.dialCode} ${clinicProvider.clinic.contact.phoneNo}'),
                              infoTile('Email', clinicProvider.clinic.email),
                              speciailty('Specialities', clinicProvider.clinic.speciality),
                              infoTile('Address', clinicProvider.clinic.address.address),
                              infoTile('Apartment', clinicProvider.clinic.address.apartment),
                              infoTile('City', clinicProvider.clinic.address.city),
                              infoTile('Pincode', clinicProvider.clinic.address.pincode),
                              infoTile('Gender', clinicProvider.clinic.gender != null ? clinicProvider.clinic.gender.toString().split('.').last : null),
                              infoTile(
                                  'Date of Birth',
                                  clinicProvider.clinic.dob != null
                                      ? '${clinicProvider.clinic.dob!.day}/${clinicProvider.clinic.dob!.month}/${clinicProvider.clinic.dob!.year}'
                                      : null),
                              SizedBox(
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegistrationScreen(
                                    isUpdateProfile: true,
                                    clinicProvider: clinicProvider,
                                  )));
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primaryL1)),
                        child: Text(
                          'Edit Profile',
                          style: R.styles.fontColorWhite,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  infoTile(label, value) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: R.styles.fz16Fw700,
          ),
          Spacer(),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
            child: Text(
              value ?? 'none',
              maxLines: 2,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: R.styles.fz16FontColorPrimary.merge(R.styles.fw500),
            ),
          )
        ],
      ),
    );
  }

  speciailty(label, List<String> value) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: R.styles.fz16Fw700,
          ),
          Spacer(),
          Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
              child: Wrap(
                spacing: 5,
                children: value
                    .map((e) => Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            // decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(100)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                '$e',
                                style: R.styles.fz16FontColorPrimary.merge(R.styles.fw500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ))
        ],
      ),
    );
  }

  Future<PicType?> _showBottomSheet(id) {
    return showModalBottomSheet<PicType?>(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        )),
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: () async {
                    // String? url = await _updateProfilePic(ImageSource.camera, id);
                    Navigator.of(context).pop(PicType.CAMERA);
                  },
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(Icons.collections),
                  title: Text('Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop(PicType.GALLERY);
                    //   String? url = await _updateProfilePic(ImageSource.gallery, id);
                  },
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever_rounded),
                  title: Text('Remove'),
                  onTap: () {
                    Navigator.of(context).pop(PicType.REMOVE);
                  },
                )
              ],
            ),
          );
        });
  }
}
