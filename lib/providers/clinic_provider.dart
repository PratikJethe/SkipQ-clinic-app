import 'dart:io';

import 'package:booktokenclinicapp/main.dart';
import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/models/clinic_token_model.dart';
import 'package:booktokenclinicapp/screens/authentication/login_screen.dart';
import 'package:booktokenclinicapp/screens/authentication/registration_screen.dart';
import 'package:booktokenclinicapp/screens/homepage/homepage_widget.dart';
import 'package:booktokenclinicapp/service/api_service.dart';
import 'package:booktokenclinicapp/service/clinic/clinic_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClinicProvider extends ChangeNotifier {
  late Clinic clinic;
  ApiService _apiService = getIt.get<ApiService>();
  bool isAuthenticated = false;

  int bottomNavIndex = 0;

  set setBottomNavIndex(index) {
    if (bottomNavIndex != index) {
      bottomNavIndex = index;
      notifyListeners();
    }
  }

  bool isLoadingTokens = false;
  List<ClinicToken> clinicPendingTokenList = [];

  ClinicService _clinicService = ClinicService();

  set setisTokenLoading(bool value) {
    isLoadingTokens = value;
    notifyListeners();
  }

  Future getClinic(BuildContext context) async {
    List<Cookie> cookiesList = await _apiService.getCookies();
    if (cookiesList.length == 0) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
      return;
    }
    ApiResponse response = await _apiService.get('/clinic/auth/get-by-id');
    if (!response.error) {
      clinic = Clinic.fromJson(response.data);
      isAuthenticated = true;
      print(clinic.toJson().toString());
      notifyListeners();
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print(response);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    }
  }

  phoneLogin(Map<String, dynamic> payload, BuildContext context) async {
    var response = await _apiService.post('/clinic/auth/phone-login', payload);
    print(response.data);
    print(response.errMsg);
    if (!response.error) {
      clinic = Clinic.fromJson(response.data);
      isAuthenticated = true;
      print(clinic.toJson().toString());
      notifyListeners();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
    } else {
      print(response);
      if (response.statusCode == 404) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => RegistrationScreen(uid: payload["uid"], mobileNumber: payload["phoneNo"])));
        return;
      }
      Fluttertoast.showToast(
          msg: response.errMsg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
    }
  }

  register(Map<String, dynamic> payload, BuildContext context) async {
    print(payload);
    var response = await _apiService.post('/clinic/auth/register', payload);
    print('dhdhd');
    print(response.errMsg);
    if (!response.error) {
      clinic = Clinic.fromJson(response.data);
      isAuthenticated = true;
      print(clinic.toJson().toString());
      notifyListeners();
      print(clinic.toString());
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
    } else {
      print(response);
      Fluttertoast.showToast(
          msg: "${response.errMsg}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
    }
  }

  Future logout(BuildContext context) async {
    _apiService.clearCookies().then((value) {
      isAuthenticated = false;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Failed to logout", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
    });
  }

  getPendingTokens() async {
    clinicPendingTokenList.clear();
    setisTokenLoading = true;
    ServiceResponse serviceResponse = await _clinicService.getPendingToken(clinic.id);
    setisTokenLoading = false;

    print(serviceResponse.data);
    if (serviceResponse.apiResponse.error) {
      isLoadingTokens = false;
      return;
    }
    clinicPendingTokenList.addAll(serviceResponse.data);
  }

  Future<ServiceResponse> addOfflineToken(String? name) async {
    ServiceResponse serviceResponse = await _clinicService.addOfflineToken(name);
    return serviceResponse;
  }
}
