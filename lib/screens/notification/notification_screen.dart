import 'dart:developer';

import 'package:skipq_clinic/models/api_response_model.dart';
import 'package:skipq_clinic/models/notification/notification_model.dart';
import 'package:skipq_clinic/resources/resources.dart';
import 'package:skipq_clinic/screens/notification/widget/notification_tile.dart';
import 'package:skipq_clinic/service/clinic/clinic_service.dart';
import 'package:skipq_clinic/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isFirstLoaded = false;
  bool hasError = false;
  List<dynamic> finalList = [];
  List<NotificationModel> notificationList = [];
  ClinicService _clinicService = ClinicService();
  ScrollController _scrollController = ScrollController();
  int pageNo = 0;

  bool isPaginating = false;

  getNotifications() {
    _clinicService.getNotifications(pageNo).then((response) {
      if (response.apiResponse.error) {
        hasError = true;
        isFirstLoaded = true;
      } else {
        if (response.data.length != 0) {
          notificationList.addAll(response.data);
          pageNo++;
        }
        if (response.data.length == 0) {
          Fluttertoast.showToast(
              msg: "No more notifications", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, fontSize: 16.0);
        }
        isFirstLoaded = true;
        hasError = false;
      }
      isPaginating = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNotifications();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        setState(() {
          isPaginating = true;
        });
        getNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backArrowAppbarWithTitle(context, 'Notifications'),
        body: isFirstLoaded
            ? hasError
                ? Center(
                    child: Text('Error Occured'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          NotificationTile(
                            notification: notificationList[index],
                          ),
                          if (isPaginating && index == notificationList.length - 1)
                            Center(
                              child: CircularProgressIndicator(
                                color: R.color.primaryL1,
                              ),
                            )
                        ],
                      );
                    },
                    itemCount: notificationList.length,
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: R.color.primaryL1,
                ),
              ));
  }
}
