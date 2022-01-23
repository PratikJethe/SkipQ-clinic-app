import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/subscription_model/plan_model.dart';
import 'package:booktokenclinicapp/models/subscription_model/subscription_model.dart';
import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/my-subscriptions/widget/subscription_plan.dart';
import 'package:booktokenclinicapp/service/clinic/clinic_service.dart';
import 'package:booktokenclinicapp/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backArrowAppbarWithTitle(context, 'Subscription Plan'),
      body: SafeArea(
        child: Consumer<ClinicProvider>(
          builder: (context, clinicProvider, _) => Container(
            child: FutureBuilder<ServiceResponse>(
              future: ClinicService().getSubscriptionDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: R.color.primaryL1,
                  ));
                }

                if (snapshot.hasError || snapshot.data!.apiResponse.error) {
                  print(snapshot.error);
                  return Center(
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
                                setState(() {});
                              },
                              child: Text(
                                'Retry',
                                style: R.styles.fontColorWhite.merge(R.styles.fz16Fw500),
                              ),
                            ))
                      ],
                    ),
                  );
                }
                if (!snapshot.data!.data!["isSubscriptionRequired"]) {
                  return Center(child: Text("Currently subscription is not required"));
                }
                SubscriptionModel lastSubscription = snapshot.data!.data!["lastClinicSubscription"] as SubscriptionModel;
                List<PlanModel> availablePlans = snapshot.data!.data!["availablePlans"].toList() as List<PlanModel>;
                bool hasActivePlan = lastSubscription.subEndDate.isAfter(DateTime.now());

                return SubscriptionPlans(availablePlans: availablePlans, hasActivePlan: hasActivePlan, lastSubscription: lastSubscription);
              },
            ),
          ),
        ),
      ),
    );
  }
}
