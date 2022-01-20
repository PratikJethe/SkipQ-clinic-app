import 'package:booktokenclinicapp/models/subscription_model/plan_model.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatefulWidget {
  final PlanModel plan;
  final selectedId;
  final Function setId;
  const PlanCard({Key? key, required this.plan, required this.selectedId, required this.setId}) : super(key: key);

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  late PlanModel plan;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    plan = widget.plan;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.setId(plan.id);
      },
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 130,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${plan.duration} ${plan.duration == 1 ? 'month' : 'months'}',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      'Rs ${plan.amount.round()}',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                          height: 30,
                        ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        
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
 widget.selectedId==plan.id?
                    Icon(Icons.check_circle,size:40,color: R.color.primary):Icon(Icons.check_circle_outline,size:40,color: R.color.black)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
