import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/authentication/otp_screens/otp_verification.dart';
import 'package:booktokenclinicapp/screens/authentication/registration_screen.dart';
import 'package:booktokenclinicapp/service/firebase_services/auth_service.dart';
import 'package:booktokenclinicapp/service/firebase_services/firebase_service.dart';
import 'package:booktokenclinicapp/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? number;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  onSaved() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.primary,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.65,
              child: Stack(
                children: [
                  PageView(
                    onPageChanged: (int index) {
                      _currentPageNotifier.value = index;
                    },
                    controller: _pageController,
                    children: [
                      OnboardingGuide(path: 'queue.png', title: 'Tiered of managing crowd in clinic? Now manage your queue online.'),
                      OnboardingGuide(path: 'notification-small.png', title: 'Notify your patients when its their turn'),
                      OnboardingGuide(path: 'search.png', title: 'Increase your reach by leveraging our  location based search'),
                      FreeTrial()
                      // OnboardingGuide(path: 'queue.jpg', title: 'Why wait in queue'),
                      // OnboardingGuide(path: 'queue.jpg', title: 'Why wait in queue'),
                    ],
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CirclePageIndicator(
                        itemCount: 4,
                        currentPageNotifier: _currentPageNotifier,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Text('Lets get you verified, enter your mobile number', style: R.styles.fz18Fw500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 50,
                      decoration: BoxDecoration(border: Border.all(color: R.color.black), borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpVerification()));
                        },
                        child: AbsorbPointer(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '+91',
                                style: R.styles.fz20Fw500,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: R.color.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingGuide extends StatelessWidget {
  final String path;
  final String title;

  const OnboardingGuide({Key? key, required this.path, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset(
                  'assets/images/${path}',
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: R.styles.fz18Fw500.merge(R.styles.fontColorWhite),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FreeTrial extends StatelessWidget {
  const FreeTrial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                    child: Text(
                  'Get Free Trial',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                )),
              ),
              Text.rich(TextSpan(children: <InlineSpan>[
                TextSpan(
                  text: '30',
                  style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextSpan(
                  text: ' days',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ])),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                    child: Text(
                  'Register now to start your free trial',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.center,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
