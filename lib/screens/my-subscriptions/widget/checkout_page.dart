import 'dart:io';

import 'package:booktokenclinicapp/config/app_config.dart';
import 'package:booktokenclinicapp/constants/api_constant.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../main.dart';

class CheckoutPage extends StatefulWidget {
  final String planId;
  const CheckoutPage({Key? key, required this.planId}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<Cookie> cookies = [];

  bool showSuccess = false;
  bool showFailure = false;
  AppConfig _appConfig = getIt.get<AppConfig>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIt.get<ApiService>().getCookies().then((cookieList) {
      cookies = cookieList;

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('${_appConfig.endPoint}/clinic/transaction/get-payment-checkout?planId=${widget.planId}');
    return Scaffold(
      body: cookies.length == 0
          ? Center(
              child: CircularProgressIndicator(
                color: R.color.primaryL1,
              ),
            )
          : showSuccess
              ? ResultTile(isSuccess: true)
              : showFailure
                  ? ResultTile(
                      isSuccess: false,
                    )
                  : WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      initialCookies: [...cookies.map((cookie) => WebViewCookie(name: cookie.name, value: cookie.value, domain: _appConfig.baseUrl))],
                      initialUrl: '${_appConfig.endPoint}/clinic/transaction/get-payment-checkout?planId=${widget.planId}',
                      navigationDelegate: (navigation) {
                        print(navigation.url);
                        print(navigation.url.contains('success'));
                        if (navigation.url.contains('success')) {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResultScreen(isSuccess: true)));
                        }
                        if (navigation.url.contains('failed')) {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResultScreen(isSuccess: false)));
                        }
                        return NavigationDecision.navigate;
                      },
                    ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final bool isSuccess;
  const ResultScreen({Key? key, required this.isSuccess}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResultTile(
        isSuccess: widget.isSuccess,
      ),
    );
  }
}

class ResultTile extends StatelessWidget {
  final bool isSuccess;
  const ResultTile({Key? key, required this.isSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSuccess ? Icons.thumb_up : Icons.thumb_down,
            size: 200,
            color: isSuccess ? Colors.green : Colors.red,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            isSuccess ? 'Payment Succesful' : 'Payment Failed',
            style: R.styles.fz20Fw700,
          ),
          SizedBox(
            height: 20,
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
                Navigator.pop(context);
              },
              child: Text(
                'Okay',
                style: R.styles.fontColorWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
