import 'package:booktokenclinicapp/constants/globals.dart';
import 'package:booktokenclinicapp/models/general_model/contact_model.dart';
import 'package:booktokenclinicapp/models/general_model/clinic_address_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'clinic_model.g.dart';

@JsonSerializable()
class Clinic {
  @JsonKey(name: '_id')
  String id;
  String doctorName;
  String clinicName;
  String authProvider;
  String fcm;
  ClinicAddress address;
  Gender? gender;
  String? email;
  Contact contact;
  String? profilePicUrl;
  @JsonKey(name:'dateOfBirth')
  DateTime? dob;
  bool isVerified;
  List<String> speciality;
  bool isSubscribed;
  DateTime subStartDate;
  DateTime subEndDate;
  bool hasClinicStarted;

  Clinic({
    required this.id,
    required this.clinicName,
    required this.authProvider,
    required this.fcm,
    required this.doctorName,
    required this.hasClinicStarted,
    required this.isSubscribed,
    required this.isVerified,
    required this.speciality,
    required this.subEndDate,
    required this.subStartDate,
    required this.address,
    required this.contact,
    this.gender,
    this.email,
    this.profilePicUrl,
    this.dob,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ClinicToJson`.
  Map<String, dynamic> toJson() => _$ClinicToJson(this);
}
