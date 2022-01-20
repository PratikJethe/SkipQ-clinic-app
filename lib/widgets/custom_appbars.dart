import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:flutter/material.dart';

backArrowAppbar(context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.arrow_back_ios),
      color: R.color.black,
    ),
  );
}

backArrowAppbarWithTitle(context, String text) {
  return AppBar(
    elevation: 0,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Text(
      text,
      style: R.styles.fz20Fw500.merge(R.styles.fontColorBlack),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.arrow_back_ios),
      color: R.color.black,
    ),
  );
}

appbarWithTitle(context, String text) {
  return AppBar(
    centerTitle: false,
    elevation: 0,
    titleSpacing: 15,
    backgroundColor: Colors.white,
    title: Text(
      text,
      style: R.styles.fz20Fw500.merge(R.styles.fontColorBlack),
    ),
  );
}

appBarWithDrawerIcon(Widget drawerIcon, String? title, context) {
  return AppBar(
    centerTitle: false,
    elevation: 0,
    titleSpacing: 0,
    leading: drawerIcon,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: (title != null)
        ? Text(
            title,
            style: R.styles.fz16FontColorBlack,
          )
        : null,
  );
}
