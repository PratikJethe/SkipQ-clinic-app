import 'dart:ffi';

import 'package:skipq_clinic/config/app_config.dart';
import 'package:skipq_clinic/constants/api_constant.dart';
import 'package:skipq_clinic/main.dart';
import 'package:skipq_clinic/models/api_response_model.dart';
import 'package:skipq_clinic/models/clinic_model.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:skipq_clinic/screens/modal-screen/modal_loading_screen.dart';
import 'package:skipq_clinic/service/firebase_services/fcm_service.dart';
import 'package:skipq_clinic/service/firebase_services/firebase_service.dart';
import 'package:skipq_clinic/utils/validators.dart';
import 'package:skipq_clinic/widgets/custom_appbars.dart';
import 'package:skipq_clinic/widgets/textfield_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

AppConfig _appConfig = getIt.get<AppConfig>();

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _appConfig.googleMapApiKeys);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, this.uid, this.mobileNumber, this.isUpdateProfile, this.clinicProvider}) : super(key: key);

  final String? uid;
  final int? mobileNumber;
  final bool? isUpdateProfile;
  final ClinicProvider? clinicProvider;

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _clinicNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _apartemntController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  TextStyle errorTextStyle = R.styles.fz14.merge(TextStyle(color: Colors.red.shade700));

  String? uid;
  int? mobileNumber;
  late Clinic clinic;

  ClinicProvider? clinicProvider;
  bool? isUpdateProfile;
  String specialityFilterString = '';
  bool isSpecialityLoading = true;
  bool errorSpecialityLoading = false;

  String? name, email, address, apartment, pincode, dob, gender = '', city, clinicName;
  List<String> genderList = ['MALE', 'FEMALE', 'OTHER', ''];
  List<double> coordinates = [];
  FcmService _fcmService = getIt.get<FcmService>();
  DateTime? selectedDate;
  DateTime initialDate = DateTime(DateTime.now().year - 10, 12, 31);

  List<dynamic> doctorSpeciality = [];

  bool errorInSpeciality = false;

  List<String> selecetdSepaciality = [];

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: initialDate, firstDate: DateTime(1900, 1), lastDate: DateTime(DateTime.now().year - 10, 12, 31));

    if (picked == null) {
      print('picked');
      print(dob);
      selectedDate = null;
      _dobController.clear();
      dob = null;
    } else {
      dob = picked.toIso8601String();
      selectedDate = picked;
      _dobController.text = '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      setState(() {});
    }
  }

  _updateUi() {
    setState(() {});
  }

  _loadSpeciality() async {
    ApiResponse response = await Provider.of<ClinicProvider>(context, listen: false).getSpecialities();

    if (response.error) {
      errorSpecialityLoading = true;
      isSpecialityLoading = false;
    } else {
      errorSpecialityLoading = false;
      isSpecialityLoading = false;

      doctorSpeciality = response.data.toList().cast<String>();

      if (isUpdateProfile == true) {
        selecetdSepaciality = selecetdSepaciality.where((selected) => doctorSpeciality.contains(selected)).toList();
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    uid = widget.uid;
    isUpdateProfile = widget.isUpdateProfile;
    print("isUpdateProfile");
    print(isUpdateProfile);
    clinicProvider = widget.clinicProvider;
    mobileNumber = widget.mobileNumber;
    if (isUpdateProfile == true) {
      assert(clinicProvider != null, 'clinicProvider cant be null if isUpdateProfile is true');
    } else {
      assert(uid != null && mobileNumber != null, 'uid and mobileNumber is required if isUpdateProfile is not true');
    }

    if (isUpdateProfile == true) {
      clinic = clinicProvider!.clinic;

      name = clinic.doctorName;
      clinicName = clinic.clinicName;
      selecetdSepaciality = clinic.speciality;
      address = clinic.address.address;
      apartment = clinic.address.apartment;
      city = clinic.address.city;
      mobileNumber = clinic.contact.phoneNo;
      pincode = clinic.address.pincode;
      _fullNameController.text = name!;
      _clinicNameController.text = clinicName!;
      _addressController.text = address ?? '';
      _apartemntController.text = apartment ?? '';
      _cityController.text = city ?? '';
      _mobileNumberController.text = mobileNumber.toString();
      _pincodeController.text = pincode ?? '';
      coordinates = clinic.address.coordinates;
      if (clinic.dob != null) {
        initialDate = clinic.dob!;
        selectedDate = clinic.dob!;
        dob = selectedDate!.toIso8601String();
        _dobController.text = '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      }

      if (clinic.gender != null) {
        gender = clinic.gender.toString().split('.').last;
      }
    }

    _mobileNumberController.text = mobileNumber.toString();

    _loadSpeciality();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _fullNameController.dispose();
    _clinicNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _apartemntController.dispose();
    _addressController.dispose();
    _dobController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalLoadingScreen(
      child: Scaffold(
        appBar: backArrowAppbar(context),
        body: isSpecialityLoading
            ? Center(
                child: CircularProgressIndicator(
                color: R.color.primaryL1,
              ))
            : errorSpecialityLoading
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
                                setState(() {
                                  isSpecialityLoading = true;
                                  errorSpecialityLoading = false;
                                });
                                _loadSpeciality();
                              },
                              child: Text(
                                'Retry',
                                style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                              ),
                            ))
                      ],
                    ),
                  )
                : Consumer<ClinicProvider>(
                    builder: (context, clinicProvider, _) => SingleChildScrollView(
                      child: Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextInputComponent(
                                  'Doctor\'s Name',
                                  TextFormField(
                                    maxLength: 30,
                                    controller: _fullNameController,
                                    onChanged: (value) {
                                      setState(() {
                                        name = value.trim();
                                      });
                                    },
                                    cursorColor: R.color.primary,
                                    cursorHeight: 25,
                                    decoration: InputDecoration(
                                        prefixIconConstraints: BoxConstraints(minHeight: 30, maxWidth: 50, maxHeight: 30),
                                        prefixIcon: Container(
                                            margin: EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              border: Border(right: BorderSide(color: R.color.black)),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'Dr.',
                                              style: R.styles.fz16Fw500,
                                            ))),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder: formBorder,
                                        errorStyle: errorTextStyle,
                                        focusedBorder: formBorder,
                                        errorBorder: formErrorBorder,
                                        focusedErrorBorder: formErrorBorder),
                                    validator: validateDoctorName,
                                  ),
                                  true),
                              TextInputComponent(
                                  'Clinic\'s Name',
                                  TextFormField(
                                    maxLength: 30,
                                    cursorColor: R.color.primary,
                                    cursorHeight: 25,
                                    controller: _clinicNameController,
                                    onChanged: (value) {
                                      setState(() {
                                        clinicName = value.trim();
                                      });
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder: formBorder,
                                        errorStyle: errorTextStyle,
                                        focusedBorder: formBorder,
                                        errorBorder: formErrorBorder,
                                        focusedErrorBorder: formErrorBorder),
                                    validator: validateClinicName,
                                  ),
                                  true),
                              TextInputComponent(
                                  'Contact',
                                  TextFormField(
                                    style: R.styles.fz16Fw500,
                                    cursorColor: R.color.primary,
                                    cursorHeight: 25,
                                    decoration: InputDecoration(
                                      enabledBorder: formBorder,
                                      errorStyle: errorTextStyle,
                                      focusedBorder: formBorder,
                                      disabledBorder: formBorder,
                                      errorBorder: formErrorBorder,
                                      focusedErrorBorder: formErrorBorder,
                                      prefixIconConstraints: BoxConstraints(minHeight: 30, maxWidth: 50, maxHeight: 30),
                                      prefixIcon: Container(
                                          margin: EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            border: Border(right: BorderSide(color: R.color.black)),
                                          ),
                                          child: Center(
                                              child: Text(
                                            '+91',
                                            style: R.styles.fz16Fw500,
                                          ))),
                                    ),
                                    controller: _mobileNumberController,
                                    enabled: false,
                                  ),
                                  true),

                              if (isUpdateProfile != true)
                                TextInputComponent(
                                    'Email',
                                    TextFormField(
                                      cursorColor: R.color.primary,
                                      cursorHeight: 25,
                                      maxLength: 40,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder: formBorder,
                                          errorStyle: errorTextStyle,
                                          focusedBorder: formBorder,
                                          errorBorder: formErrorBorder,
                                          focusedErrorBorder: formErrorBorder),
                                      controller: _emailController,
                                      onChanged: (value) {
                                        setState(() {
                                          email = value.trim();
                                        });
                                      },
                                      validator: validateEmail,
                                    ),
                                    false),
                              // TextInputComponent('Full name', TextFormField(), true),  reserverd for address via google api

                              TextInputComponent(
                                  'Pincode',
                                  TextFormField(
                                    controller: _pincodeController,
                                    cursorColor: R.color.primary,
                                    cursorHeight: 25,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder: formBorder,
                                        errorStyle: errorTextStyle,
                                        focusedBorder: formBorder,
                                        errorBorder: formErrorBorder,
                                        focusedErrorBorder: formErrorBorder),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    onChanged: (value) {
                                      setState(() {
                                        pincode = value.trim();
                                      });
                                    },
                                    validator: validatePincode,
                                  ),
                                  false), // auto filled or manual
                              GestureDetector(
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());

                                  onError(res) {
                                    print(res);
                                    Fluttertoast.showToast(msg: "something went wrong. check your internet connection", gravity: ToastGravity.BOTTOM);
                                  }

                                  Prediction? prediction = await PlacesAutocomplete.show(
                                    context: context,
                                    mode: Mode.overlay,
                                    apiKey: _appConfig.googleMapApiKeys,
                                    components: [],
                                    types: [],
                                    onError: onError,
                                    strictbounds: false,
                                    hint: "Search address",
                                  );

                                  if (prediction == null) {
                                    address = null;
                                    _addressController.clear();
                                    coordinates = [];
                                    setState(() {});
                                    return;
                                  }

                                  print(prediction.description);
                                  _addressController.text = prediction.description!;
                                  address = prediction.description!;

                                  PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId!);
                                  final lat = detail.result.geometry?.location.lat;
                                  final lng = detail.result.geometry?.location.lng;

                                  if (lat != null && lng != null) {
                                    coordinates = [lng, lat];
                                    print(coordinates);
                                  }
                                },
                                child: TextInputComponent(
                                  'Address',
                                  TextFormField(
                                    enabled: false,
                                    cursorColor: R.color.primary,
                                    cursorHeight: 25,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder: formBorder,
                                        errorStyle: errorTextStyle,
                                        focusedBorder: formBorder,
                                        disabledBorder: formBorder,
                                        errorBorder: formErrorBorder,
                                        focusedErrorBorder: formErrorBorder),
                                    controller: _addressController,
                                    validator: validateAddress,
                                  ),
                                  true,
                                ),
                              ), // auto filled or manual
                              TextInputComponent(
                                'Apartment',
                                TextFormField(
                                  maxLength: 60,
                                  controller: _apartemntController,
                                  cursorColor: R.color.primary,
                                  cursorHeight: 25,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                      enabledBorder: formBorder,
                                      errorStyle: errorTextStyle,
                                      focusedBorder: formBorder,
                                      errorBorder: formErrorBorder,
                                      focusedErrorBorder: formErrorBorder),
                                  onChanged: (value) {
                                    setState(() {
                                      apartment = value.trim();
                                    });
                                  },
                                  validator: validateApartment,
                                ),
                                false,
                              ), // auto filled or manual
                              TextInputComponent(
                                'Speciality',
                                GestureDetector(
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    // setState(() {
                                    //   specialityFilterString = "";
                                    // });
                                    await _showBottomSheet();
                                    _updateUi();
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: R.color.black)),
                                        width: double.infinity,
                                        constraints: BoxConstraints(minHeight: 50),
                                        child: selecetdSepaciality.length == 0
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      'select speciality',
                                                      style: R.styles.fz16FontColorGrey,
                                                    )),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                  spacing: 10,
                                                  children: [
                                                    ...selecetdSepaciality.map((e) => ActionChip(
                                                        label: Text(e),
                                                        onPressed: () async {
                                                          FocusScope.of(context).requestFocus(FocusNode());
                                                          // setState(() {
                                                          //   specialityFilterString = "";
                                                          // });
                                                          await _showBottomSheet();
                                                          _updateUi();
                                                        }))
                                                  ],
                                                ),
                                              ),
                                      ),
                                      SizedBox(height: 5),
                                      if (errorInSpeciality)
                                        Text(
                                          'minimum 1 and maximum 3 specialities are required',
                                          style: errorTextStyle,
                                        )
                                    ],
                                  ),
                                ),
                                true,
                              ), // auto filled or manual
                              GestureDetector(
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());

                                  onError(res) {
                                    print(res);
                                    Fluttertoast.showToast(msg: "something went wrong. check your internet connection", gravity: ToastGravity.BOTTOM);
                                  }

                                  Prediction? prediction = await PlacesAutocomplete.show(
                                    context: context,

                                    mode: Mode.overlay,
                                    apiKey: _appConfig.googleMapApiKeys,
                                    // sessionToken: sessionToken,
                                    components: [],
                                    types: ['(cities)'],
                                    onError: onError,
                                    strictbounds: false,
                                    hint: "Search City",
                                  );

                                  if (prediction == null) {
                                    city = null;
                                    _cityController.clear();
                                    setState(() {});
                                    return;
                                  }

                                  if (prediction.description != null) {
                                    city = prediction.description!.split(',')[0].trim();
                                    _cityController.text = city!;
                                  }
                                },
                                child: TextInputComponent(
                                  'City',
                                  TextFormField(
                                    enabled: false,
                                    cursorColor: R.color.primary,
                                    cursorHeight: 25,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder: formBorder,
                                        errorStyle: errorTextStyle,
                                        focusedBorder: formBorder,
                                        disabledBorder: formBorder,
                                        errorBorder: formErrorBorder,
                                        focusedErrorBorder: formErrorBorder),
                                    controller: _cityController,
                                    onChanged: (value) {
                                      setState(() {
                                        city = value.trim();
                                      });
                                    },
                                    validator: validateCity,
                                  ),
                                  true,
                                ),
                              ), // auto filled or manual
                              GestureDetector(
                                onTap: () async {
                                  await _selectDate(context);
                                },
                                child: TextInputComponent(
                                  'Date of birth',
                                  TextFormField(
                                    controller: _dobController,
                                    enabled: false,
                                    cursorColor: R.color.primary,
                                    cursorHeight: 25,
                                    decoration: InputDecoration(
                                        hintText: 'Select birth date',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder: formBorder,
                                        errorStyle: errorTextStyle,
                                        focusedBorder: formBorder,
                                        disabledBorder: formBorder,
                                        errorBorder: formErrorBorder,
                                        focusedErrorBorder: formErrorBorder),
                                    onChanged: (value) {},
                                  ),
                                  false,
                                ),
                              ), // auto filled or manual

                              TextInputComponent(
                                  'Gender',
                                  FittedBox(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Radio(
                                                  fillColor: MaterialStateColor.resolveWith((states) => R.color.primary),
                                                  value: 'MALE',
                                                  groupValue: gender,
                                                  onChanged: (value) {
                                                    print(value);
                                                    gender = value.toString();
                                                    setState(() {});
                                                  }),
                                              Text('Male')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Radio(
                                                  fillColor: MaterialStateColor.resolveWith((states) => R.color.primary),
                                                  value: 'FEMALE',
                                                  groupValue: gender,
                                                  onChanged: (value) {
                                                    print(value);
                                                    setState(() {});
                                                    gender = value.toString();
                                                  }),
                                              Text('Female')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Radio(
                                                  fillColor: MaterialStateColor.resolveWith((states) => R.color.primary),
                                                  value: 'OTHER',
                                                  groupValue: gender,
                                                  onChanged: (value) {
                                                    gender = value.toString();
                                                    setState(() {});
                                                    print(value);
                                                  }),
                                              Text('Other')
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Radio(
                                                  fillColor: MaterialStateColor.resolveWith((states) => R.color.primary),
                                                  value: '',
                                                  groupValue: gender,
                                                  onChanged: (value) {
                                                    gender = '';
                                                    setState(() {});
                                                  }),
                                              Text('None')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  false),
                              // TextInputComponent('Date of Birth', TextFormField(), true),
                              TextButton(
                                onPressed: () async {
                                  print("isUpdateProfile");
                                  print(isUpdateProfile);
                                  if (isUpdateProfile == true) {
                                    print({
                                      "name": name?.trim(),
                                      "email": email == null || email!.isEmpty ? null : email,
                                      "mobileNumber": mobileNumber,
                                      "pincode": pincode,
                                      "apartment": apartment,
                                      "gender": gender!.isEmpty ? null : gender,
                                      "city": city,
                                      "dateOfBrth": dob,
                                      "address": address,
                                      "coordinates": coordinates,
                                      "profilePicUrl": clinic.profilePicUrl
                                    });

                                    print(selecetdSepaciality.length);
                                    if (selecetdSepaciality.length == 0 || selecetdSepaciality.length > 3) {
                                      setState(() {
                                        errorInSpeciality = true;
                                      });
                                    } else {
                                      setState(() {
                                        errorInSpeciality = false;
                                      });
                                    }

                                    if (_formKey.currentState!.validate() && !errorInSpeciality) {
                                      Map<String, dynamic> payload = {
                                        "doctorName": name?.trim(),
                                        "clinicName": clinicName?.trim(),
                                        "pincode": pincode == null || pincode!.isEmpty ? null : pincode,
                                        "address": address?.trim(),
                                        "apartment": apartment == null || apartment!.isEmpty ? null : apartment,
                                        "gender": gender == "" ? null : gender,
                                        "city": city == null || city!.isEmpty ? null : city,
                                        "speciality": selecetdSepaciality,
                                        "dateOfBirth": dob,
                                        "coordinates": coordinates.length < 2 ? null : coordinates,
                                        "profilePicUrl": clinic.profilePicUrl,
                                        "notice":clinic.notice
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

                                        Fluttertoast.showToast(
                                            msg: "Profile updated succesfully!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 2,
                                            fontSize: 16.0);
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  } else {
                                    print({
                                      "name": name?.trim(),
                                      "email": email == null || email!.isEmpty ? null : email,
                                      "mobileNumber": mobileNumber,
                                      "pincode": pincode,
                                      "apartment": apartment,
                                      "gender": gender!.isEmpty ? null : gender,
                                      "city": city,
                                      "dateOfBrth": dob,
                                      "fcm": '',
                                      "uid": uid,
                                      "address": address,
                                      "coordinates": coordinates,
                                    });

                                    print(selecetdSepaciality.length);
                                    if (selecetdSepaciality.length == 0 || selecetdSepaciality.length > 3) {
                                      setState(() {
                                        errorInSpeciality = true;
                                      });
                                    } else {
                                      setState(() {
                                        errorInSpeciality = false;
                                      });
                                    }

                                    if (_formKey.currentState!.validate() && !errorInSpeciality) {
                                      String? token = await _fcmService.refreshToken();

                                      if (token == null) {
                                        Fluttertoast.showToast(msg: "something went wrong. try again", gravity: ToastGravity.BOTTOM);

                                        return;
                                      }

                                      // print({
                                      //   "fullName": name?.trim(),
                                      //   "email": email == null || email!.isEmpty ? null : email,
                                      //   "phoneNo": mobileNumber,
                                      //   "pincode": pincode == null || pincode!.isEmpty ? null : pincode,
                                      //   "address": address == null || address!.isEmpty ? null : address,
                                      //   "apartment": apartment == null || apartment!.isEmpty ? null : apartment,
                                      //   "gender": gender == "" ? null : gender,
                                      //   "city": city == null || city!.isEmpty ? null : city,
                                      //   "dateOfBirth": dob,
                                      //   "fcm": token,
                                      //   "uid": uid,
                                      //   "coordinates": coordinates.length < 2 ? null : coordinates,
                                      // });

                                      // print(coordinates.length);
                                      Map<String, dynamic> payload = {
                                        "doctorName": name?.trim(),
                                        "clinicName": clinicName?.trim(),
                                        "email": email == null || email!.isEmpty ? null : email,
                                        "phoneNo": mobileNumber,
                                        "pincode": pincode == null || pincode!.isEmpty ? null : pincode,
                                        "address": address?.trim(),
                                        "apartment": apartment == null || apartment!.isEmpty ? null : apartment,
                                        "gender": gender == "" ? null : gender,
                                        "city": city == null || city!.isEmpty ? null : city,
                                        "speciality": selecetdSepaciality,
                                        "dateOfBirth": dob,
                                        "fcm": token,
                                        "uid": uid,
                                        "coordinates": coordinates.length < 2 ? null : coordinates,
                                      };
                                      print(payload);
                                      payload.removeWhere((key, value) => value == null || value == '');
                                      clinicProvider.setShowModalLoading = true;
                                      await clinicProvider.register(payload, context);
                                      clinicProvider.setShowModalLoading = false;
                                    }
                                  }
                                },
                                child: Card(
                                  child: Container(
                                      width: 160,
                                      height: 40,
                                      color: R.color.primaryL1,
                                      child: Center(
                                          child: Text(
                                        '${isUpdateProfile == true ? "Update" : "Register"}',
                                        style: R.styles.fz16Fw500.merge(TextStyle(color: Colors.white)),
                                      ))),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Future _showBottomSheet() async {
    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: double.infinity,
                    height: 60,
                    child: Center(
                        child: Text(
                      'Select min 1 and max 3 specialities',
                      style: R.styles.fz16Fw500,
                    ))),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: double.infinity,
                  child: TextFormField(
                    initialValue: specialityFilterString,
                    autofocus: true,
                    cursorColor: R.color.primary,
                    decoration: InputDecoration(
                      hintText: 'Search for speciality',
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: R.color.primary)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: R.color.primary)),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: R.color.primary)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        specialityFilterString = value.trim();
                      });
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...doctorSpeciality.map(
                          (e) => e.toLowerCase().contains(specialityFilterString.toLowerCase()) || specialityFilterString.isEmpty
                              ? CheckboxListTile(
                                  title: Text(e),
                                  value: selecetdSepaciality.contains(e),
                                  onChanged: (value) {
                                    print(value);
                                    if (value == true) {
                                      if (selecetdSepaciality.length == 3) {
                                        Fluttertoast.showToast(
                                            msg: "Already 3 specialities selected",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 2,
                                            fontSize: 16.0);
                                        return;
                                      }
                                      setState(() {
                                        selecetdSepaciality.add(e);
                                      });
                                    }
                                    if (value == false) {
                                      setState(() {
                                        selecetdSepaciality.remove(e);
                                      });
                                    }
                                  },
                                )
                              : Container(),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0), side: BorderSide.none)),
                        backgroundColor: MaterialStateProperty.all(
                          R.color.primaryL1,
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        visualDensity: VisualDensity(vertical: 0, horizontal: 0)),
                    onPressed: () {
                      _updateUi();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Submit',
                      style: R.styles.fontColorWhite,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class TextInputComponent extends StatefulWidget {
  final String fieldName;
  final Widget textFormField;
  final bool isRequired;

  TextInputComponent(this.fieldName, this.textFormField, this.isRequired);

  @override
  _TextInputComponentState createState() => _TextInputComponentState();
}

class _TextInputComponentState extends State<TextInputComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.fieldName,
                style: R.styles.fz16Fw500,
              ),
              SizedBox(width: 5),
              widget.isRequired ? Text('(required)') : Text('(optional)')
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(child: widget.textFormField)
        ],
      ),
    );
  }
}
