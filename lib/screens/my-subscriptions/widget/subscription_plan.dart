import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/subscription_model/order_model.dart';
import 'package:booktokenclinicapp/models/subscription_model/plan_model.dart';
import 'package:booktokenclinicapp/models/subscription_model/subscription_model.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/my-subscriptions/widget/checkout_page.dart';
import 'package:booktokenclinicapp/screens/my-subscriptions/widget/plan_card.dart';
import 'package:booktokenclinicapp/screens/my-subscriptions/widget/subscription_card.dart';
import 'package:booktokenclinicapp/service/clinic/clinic_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class SubscriptionPlans extends StatefulWidget {
  final bool hasActivePlan;
  final List<PlanModel> availablePlans;
  final SubscriptionModel lastSubscription;
  const SubscriptionPlans({Key? key, required this.availablePlans, required this.hasActivePlan, required this.lastSubscription}) : super(key: key);

  @override
  _SubscriptionPlansState createState() => _SubscriptionPlansState();
}

class _SubscriptionPlansState extends State<SubscriptionPlans> {
  late bool hasActivePlan;
  late List<PlanModel> availablePlans;
  late SubscriptionModel lastSubscription;
  String? selectedPlanId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hasActivePlan = widget.hasActivePlan;
    availablePlans = widget.availablePlans;
    lastSubscription = widget.lastSubscription;
  }

  void setSelectedId(id) {
    setState(() {
      selectedPlanId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  hasActivePlan ? Text('Active Plan',style: R.styles.fz16Fw700,) : Text('Plans',style: R.styles.fz16Fw700,),
                  SizedBox(
                    height: 10,
                  ),
                  if (hasActivePlan) SubscriptionCard(subscription: lastSubscription),
                  if (!hasActivePlan)
                    for (var i = 0; i < availablePlans.length; i++)
                      PlanCard(
                        plan: availablePlans[i],
                        selectedId: selectedPlanId,
                        setId: setSelectedId,
                      )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      if(!hasActivePlan)  SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(R.color.primary),
              ),
              onPressed: () {
                print(selectedPlanId);
                if (selectedPlanId != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CheckoutPage(planId: selectedPlanId!)));
                }
              },
              child: Text(
                'Activate',
                style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
              ),
            )),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class PriceCard extends StatelessWidget {
  final int month;

  const PriceCard({Key? key, required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () async {
          ClinicService clinicService = ClinicService();

          ServiceResponse serviceResponse = await clinicService.getTransactionToken(month);

          if (serviceResponse.apiResponse.error) {
            Fluttertoast.showToast(
                msg: serviceResponse.apiResponse.errMsg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                fontSize: 16.0);
            return;
          }

          OrderModel order = serviceResponse.data;
          // FlutterPayuUnofficial.initiatePayment(paymentParams: PaymentParams(merchantID: merchantID, merchantKey: merchantKey, salt: salt, amount: amount, transactionID: transactionID, phone: phone, productName: productName, firstName: firstName, email: email, sURL: sURL, fURL: fURL, udf1: udf1, udf2: udf2, udf3: udf3, udf4: udf4, udf5: udf5, udf6: udf6, udf7: udf7, udf8: udf8, udf9: udf9, udf10: udf10, hash: hash))
          // try {
          //   print(order.callbackUrl);
          //   var response =
          //       AllInOneSdk.startTransaction(order.mid, order.orderId, order.ammount.toString(), order.txnToken, order.callbackUrl, true, true);
          //   response.then((value) {
          //     print('then');
          //     print(value);
          //   }).catchError((onError) {
          //     print('first error');
          //     print(onError);
          //     Fluttertoast.showToast(
          //         msg: 'Something went wrong..try again!',
          //         toastLength: Toast.LENGTH_SHORT,
          //         gravity: ToastGravity.BOTTOM,
          //         timeInSecForIosWeb: 2,
          //         fontSize: 16.0);
          //   });
          // } catch (err) {
          //   print('second error');

          //   print(err);

          //   Fluttertoast.showToast(
          //       msg: 'Something went wrong..try again!',
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.BOTTOM,
          //       timeInSecForIosWeb: 2,
          //       fontSize: 16.0);
          // }
        },
        child: AbsorbPointer(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              child: Row(
                children: [
                  Text('${month} Month'),
                  SizedBox(
                    width: 20,
                  ),
                  Text('${month * 299} Rs-/'),
                ],
              )),
        ),
      ),
    );
  }
}
