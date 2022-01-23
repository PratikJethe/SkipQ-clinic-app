import 'package:booktokenclinicapp/providers/clinic_provider.dart';
import 'package:booktokenclinicapp/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorProfileWidget extends StatefulWidget {
  final double? width;
  final double? height;
  const DoctorProfileWidget({Key? key, this.height, this.width}) : super(key: key);

  @override
  _DoctorProfileWidgetState createState() => _DoctorProfileWidgetState();
}

class _DoctorProfileWidgetState extends State<DoctorProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClinicProvider>(builder: (context, clinicProvider, _) {
      return Container(
          width: widget.width ?? 60,
          height: widget.height ?? 100,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          child: clinicProvider.clinic.profilePicUrl != null
              ? Image.network(
                  clinicProvider.clinic.profilePicUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                                                  color: R.color.primaryL1,

                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, _, __) => Icon(Icons.error),
                )
              : FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    // size: 140,
                  ),
                ));
    });
  }
}

class UserProfileWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxShape shape;
  final String? url;
  final String? defaultUrl;
  final Widget? errorWidget;

  const UserProfileWidget({Key? key, this.height, this.width, this.shape = BoxShape.rectangle, this.defaultUrl, this.url, this.errorWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(url);
    return Container(
        width: width ?? 60,
        height: height ?? 100,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(color: Colors.grey, shape: shape),
        child: url != null
            ? Image.network(
                url!,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                                                color: R.color.primaryL1,

                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, _, __) => errorWidget ?? Icon(Icons.error),
              )
            : FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  // size: 140,
                ),
              ));
  }
}
