import 'package:skipq_clinic/providers/clinic_provider.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalLoadingScreen extends StatelessWidget {
  final Widget child;
  const ModalLoadingScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
      return Stack(
        children: [
          child,
          if (clinicProvider.showModalLoading)
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    child: ModalBarrier(dismissible: false, color: Colors.grey),
                    opacity: 0.7,
                  ),
                  Positioned(
                      height: 80,
                      width: 200,
                      child: Material(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: R.color.primaryL1,
                                  ),
                                ),
                                SizedBox(width: 30),
                                Text(
                                  'Please Wait',
                                  style: TextStyle(),
                                  textScaleFactor: 1.5,
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            )
        ],
      );
    }));
  }
}
