import 'package:booktokenclinicapp/models/notification/notification_model.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:booktokenclinicapp/screens/profile/widget/profile_image.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatefulWidget {
  final NotificationModel notification;
  const NotificationTile({Key? key, required this.notification}) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  late NotificationModel notification;
  @override
  void initState() {
    super.initState();
    notification = widget.notification;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DoctorProfileWidget(),
      title: Text(notification.title),
      subtitle: Text(notification.subtitle??""),
      trailing:!notification.isSeen? Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
        color: R.color.primary,
          shape: BoxShape.circle
        ),
      ):null,
    );
  }
}
