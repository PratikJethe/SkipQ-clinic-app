import 'package:skipq_clinic/constants/globals.dart';
import 'package:skipq_clinic/models/clinic_general_model/contact_model.dart';
import 'package:skipq_clinic/models/user/general_model/user_address_model.dart';
import 'package:skipq_clinic/utils/date_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String id;
  String fullName;
  String authProvider;
  String fcm;
  UserAddress? address;
  Gender? gender;
  String? email;
  Contact contact;
  String? profilePicUrl;

  @JsonKey(name: 'dateOfBirth', fromJson: utcToLocalOptional)
  DateTime? dob;

  User({
    required this.id,
    required this.fullName,
    required this.authProvider,
    required this.fcm,
    this.address,
    required this.gender,
    required this.contact,
    this.email,
    this.profilePicUrl,
    this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

// resolveGender(String? gender) {
//   if (gender == null) {
//     return Gender.NONE;
//   }
//   if (gender == "MALE") {
//     return Gender.MALE;
//   }
//   if (gender == "FEMALE") {
//     return Gender.FEMALE;
//   }
//   if (gender == "OTHER") {
//     return Gender.OTHER;
//   }
// }

// resolveReverseGender(Enum gender) {
//   if (gender == Gender.NONE) {
//     return null;
//   }
//   if (gender == Gender.MALE) {
//     return "MALE";
//   }
//   if (gender == Gender.FEMALE) {
//     return "FEMALE";
//   }
//   if (gender == Gender.OTHER) {
//     return "OTHER";
//   }

