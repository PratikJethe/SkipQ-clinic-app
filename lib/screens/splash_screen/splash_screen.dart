import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/authentication/registration_screen.dart';
import 'package:booktokenclinicapp/service/initialize_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool initializeError = false;

  @override
  void initState() {
    super.initState();
    //initialize all requirements
    InitializeApp().initialze(context).then((value) {
      print(value);
      if (!value) {
        initializeError = true;
        if (mounted) {
          setState(() {});
        }
        return;
      }
      Provider.of<ClinicProvider>(context, listen: false).getClinic(context);
    }).catchError((e) {
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
      child: Consumer<ClinicProvider>(
        builder: (context, userProvider, _) {
          return !initializeError
              ?
              // RegistrationScreen(uid: 'djdjdj', mobileNumber: 9090909090)

              Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Book Online Token',
                          style: TextStyle(color: R.color.primary, fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 40),
                        CircularProgressIndicator(
                          color: R.color.primaryL1,
                        )
                      ],
                    ),
                  ),
                )
              : Text('something went wrong'); // TODO create proper error code
        },
      ),
    );
  }
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