import 'package:flutter_svg/flutter_svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:skipq_clinic/config/app_config.dart';
import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:skipq_clinic/screens/authentication/registration_screen.dart';
import 'package:skipq_clinic/service/initialize_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool initializeError = false;
  bool isUpdateRequired = false;
  @override
  void initState() {
    super.initState();
    // initialize all requirements
    InitializeApp().initialze(context).then((value) async {
      print(value);
      if (!value) {
        initializeError = true;
        if (mounted) {
          setState(() {});
        }
        return;
      }
      isUpdateRequired = await getIt.get<AppConfig>().isUpdateRequired();
      if (mounted) {
        setState(() {});
      }
      if (isUpdateRequired) {
        showAlertDialog(context);
        return;
      }

      Provider.of<ClinicProvider>(context, listen: false).getClinic(context);
    }).catchError((e) {
      print(e);
      initializeError = true;
      if (mounted) {
        setState(() {});
      }
    });

    //if fetch user and navigate a  ccording to it
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: !initializeError
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: SvgPicture.asset(
                      'assets/images/splash_logo.svg',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    )),
                    Text(
                      'SkipQ Clinic',
                      style: TextStyle(color: R.color.primary, fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 40),
                    CircularProgressIndicator(
                      color: R.color.primaryL1,
                    )
                  ],
                ),
              ),
            )
          : Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text('Something went wrong!..try again')],
                ),
              ),
            ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.2,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(R.color.primary),
        ),
        onPressed: () async {
          AppConfig _appConfig = getIt.get<AppConfig>();

          LaunchReview.launch(androidAppId: _appConfig.androidAppId);
        },
        child: Text(
          'Update',
          style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
        ),
      ));

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "New Update Available",
      style: R.styles.fz18Fw500.merge(R.styles.fontColorPrimary),
    ),
    content: Text("Plaease update your app to latest vaerison"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
//         id: json["_id"].toString(),
//         clinicName: json["clinicName"],
//         authProvider: json["authProvider"],
//         fcm: json["fcm"],
//         doctorName: json["doctorName"],
//         hasClinicStated: json["hasClinicStated"],
//         isSubscribed: json["isSubscribed"],
//         isVerified: json["isVerified"],
//         speciality: json["speciality"],
//         subEndDate: json["subEndDate"],
//         subStartDate: json["subStartDate"],
//         address: Address.fromJson(json["address"]) ,
//         contact: Contact.fromJson(json["contact"]),
//         gender: resolveGender(json["gender"]),
//         email: json["email"],
//         profilePicUrl: json["profilePicUrl"],
//         dob: json["dateOfBirth"] != null ? DateTime.parse(json["dateOfBirth"]) : null,
//       );