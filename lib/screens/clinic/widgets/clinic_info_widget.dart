import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:flutter/material.dart';

class ClinicInfoWidget extends StatefulWidget {
  final Clinic clinic;

  const ClinicInfoWidget({Key? key, required this.clinic}) : super(key: key);

  @override
  _ClinicInfoWidgetState createState() => _ClinicInfoWidgetState();
}

class _ClinicInfoWidgetState extends State<ClinicInfoWidget> {
  late Clinic clinic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clinic = widget.clinic;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Container(
            // clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: R.color.primary,width: 2),
            image: DecorationImage(image: NetworkImage(clinic.profilePicUrl??''))
            ),
            height: MediaQuery.of(context).size.height * 0.17,
            width: MediaQuery.of(context).size.width * 0.25,
            child: Container()
            
            // Image.network(
            //   clinic.profilePicUrl ?? '',
            //   fit: BoxFit.fill,
            // ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dr. ${clinic.doctorName}'),
                Text('${clinic.speciality.first}'),
                Row(
                  children: [
                    Icon(Icons.phone),
                    Text('${clinic.contact.phoneNo}'),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.4,
                  child: TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(R.color.primary)),
                    onPressed: (){}, child: Text('${!clinic.hasClinicStarted?'Open Clinic':'Close Clinic'}',style: R.styles.fontColorWhite,)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
