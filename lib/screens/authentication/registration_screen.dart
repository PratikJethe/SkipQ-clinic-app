import 'dart:ffi';

import 'package:booktokenclinicapp/config/config.dart';
import 'package:booktokenclinicapp/constants/api_constant.dart';
import 'package:booktokenclinicapp/main.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/service/firebase_services/fcm_service.dart';
import 'package:booktokenclinicapp/service/firebase_services/firebase_service.dart';
import 'package:booktokenclinicapp/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Config.autocompleteApiKey);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, required this.uid, required this.mobileNumber}) : super(key: key);

  final String uid;
  final int mobileNumber;

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

  late String uid;
  late int mobileNumber;

  String specialityFilterString = '';

  String? name, email, address, apartment, pinocde, dob, gender = '', city, clinicName;
  List<String> genderList = ['MALE', 'FEMALE', 'OTHER', ''];
  List<double> coordinates = [];
  FcmService _fcmService = getIt.get<FcmService>();
  DateTime? selectedDate;

  bool errorInSpeciality = false;

  List<String> selecetdSepaciality = [];

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 10, 12, 31),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(DateTime.now().year - 10, 12, 31));

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

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    mobileNumber = widget.mobileNumber;
    _mobileNumberController.text = mobileNumber.toString();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Screen'),
      ),
      body: Consumer<ClinicProvider>(
        builder: (context, clinicProvider, _) => SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextInputComponent(
                      'Doctor\'s Name',
                      TextFormField(
                        maxLength: 20,
                        controller: _fullNameController,
                        onChanged: (value) {
                          setState(() {
                            name = value.trim();
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        validator: validateDoctorName,
                      ),
                      true),
                  TextInputComponent(
                      'Clinic\'s Name',
                      TextFormField(
                        maxLength: 20,
                        controller: _clinicNameController,
                        onChanged: (value) {
                          setState(() {
                            clinicName = value.trim();
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        validator: validateClinicName,
                      ),
                      true),
                  TextInputComponent(
                      'Mobile Number',
                      TextFormField(
                        controller: _mobileNumberController,
                        enabled: false,
                      ),
                      true),

                  TextInputComponent(
                      'Email',
                      TextFormField(
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
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {
                            pinocde = value.trim();
                          });
                        },
                        validator: validatePincode,
                      ),
                      false), // auto filled or manual
                  GestureDetector(
                    onTap: () async {
                      onError(res) {
                        print(res);
                        Fluttertoast.showToast(msg: "something went wrong. check your internet connection", gravity: ToastGravity.BOTTOM);
                      }

                      Prediction? prediction = await PlacesAutocomplete.show(
                        context: context,
                        mode: Mode.overlay,
                        apiKey: Config.autocompleteApiKey,
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
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Theme.of(context).errorColor, // or any other color
                          ),
                        ),
                        controller: _addressController,
                        validator: validateAddress,
                      ),
                      false,
                    ),
                  ), // auto filled or manual
                  TextInputComponent(
                    'Apartment',
                    TextFormField(
                      maxLength: 50,
                      controller: _apartemntController,
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
                        await _showBottomSheet();
                        _updateUi();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                            width: double.infinity,
                            constraints: BoxConstraints(minHeight: 60),
                            child: selecetdSepaciality.length == 0
                                ? Align(alignment: Alignment.centerLeft, child: Text('select speciality'))
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Wrap(
                                      spacing: 10,
                                      children: [...selecetdSepaciality.map((e) => ActionChip(label: Text(e), onPressed: () {}))],
                                    ),
                                  ),
                          ),
                          if (errorInSpeciality)
                            Text(
                              'Minimum 1 and Maximum 3 specialities are required',
                              style: TextStyle(color: Colors.red),
                            )
                        ],
                      ),
                    ),
                    true,
                  ), // auto filled or manual
                  GestureDetector(
                    onTap: () async {
                      onError(res) {
                        print(res);
                        Fluttertoast.showToast(msg: "something went wrong. check your internet connection", gravity: ToastGravity.BOTTOM);
                      }

                      Prediction? prediction = await PlacesAutocomplete.show(
                        context: context,
                        mode: Mode.overlay,
                        apiKey: Config.autocompleteApiKey,
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
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Theme.of(context).errorColor, // or any other color
                          ),
                        ),
                        controller: _cityController,
                        onChanged: (value) {
                          setState(() {
                            city = value.trim();
                          });
                        },
                        validator: validateCity,
                      ),
                      false,
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
                        decoration: const InputDecoration(hintText: 'Select birth date'),
                        onChanged: (value) {},
                      ),
                      false,
                    ),
                  ), // auto filled or manual

                  TextInputComponent(
                      'Gender',
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
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
                      true),
                  // TextInputComponent('Date of Birth', TextFormField(), true),
                  MaterialButton(
                    onPressed: () async {
                      print({
                        "name": name?.trim(),
                        "email": email == null || email!.isEmpty ? null : email,
                        "mobileNumber": mobileNumber,
                        "pincode": pinocde,
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
                      }

                      if (_formKey.currentState!.validate() && errorInSpeciality) {
                        String? token = await _fcmService.refreshToken();

                        if (token == null) {
                          Fluttertoast.showToast(msg: "something went wrong. try again", gravity: ToastGravity.BOTTOM);

                          return;
                        }

                        // print({
                        //   "fullName": name?.trim(),
                        //   "email": email == null || email!.isEmpty ? null : email,
                        //   "phoneNo": mobileNumber,
                        //   "pincode": pinocde == null || pinocde!.isEmpty ? null : pinocde,
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
                          "pincode": pinocde == null || pinocde!.isEmpty ? null : pinocde,
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
                        await clinicProvider.register(payload, context);
                      }
                    },
                    child: Text('Submit'),
                  )
                ],
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
                Container(width: double.infinity, height: 60, child: Center(child: Text('Select min 1 and max 3 specialities'))),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search for speciality',
                      border: UnderlineInputBorder(),
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
                        ...doctorSpecialty.map(
                          (e) => e.toLowerCase().contains(specialityFilterString.toLowerCase()) || specialityFilterString.isEmpty
                              ? CheckboxListTile(
                                  title: Text(e),
                                  value: selecetdSepaciality.contains(e),
                                  onChanged: (value) {
                                    print(value);
                                    if (value == true) {
                                      if (selecetdSepaciality.length == 3) {
                                        Fluttertoast.showToast(
                                            msg: "Alreday 3 specialities selected",
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
                TextButton(
                    onPressed: () {
                      _updateUi();
                      Navigator.pop(context);
                    },
                    child: Text('Sumbit'))
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
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(widget.fieldName), widget.textFormField],
      ),
    );
  }
}
