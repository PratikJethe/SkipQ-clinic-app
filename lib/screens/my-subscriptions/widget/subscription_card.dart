import 'package:skipq_clinic/constants/globals.dart';
import 'package:skipq_clinic/models/subscription_model/subscription_model.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  const SubscriptionCard({Key? key, required this.subscription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 150,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rs ',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          TextSpan(
                            text: '${subscription.plan.amount.round()} /',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          TextSpan(text: '${subscription.plan.duration} ${subscription.plan.duration == 1 ? 'month' : 'months'}'),
                        ],
                      ),
                    ),
                    subscription.subscriptionType == SubscriptionType.FREE_TRIAL
                        ? Container(
                            decoration: BoxDecoration(color: R.color.primaryL1, borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Free Trial',
                                style: R.styles.fontColorWhite.merge(R.styles.fz12),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${subscription.subEndDate.difference(DateTime.now()).inDays.toString()} days left',
                  style: R.styles.fz16Fw700.merge(R.styles.fontColorBluishGrey),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Plan Benefit',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Text(
                  'Digital Queue',
                  style: R.styles.fz14.merge(R.styles.fontColorBluishGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
