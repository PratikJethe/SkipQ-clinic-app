import 'dart:developer';

import 'package:booktokenclinicapp/constants/globals.dart';
import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/models/user/user_model.dart';

import 'package:booktokenclinicapp/utils/date_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clinic_token_model.g.dart';

@JsonSerializable()
class ClinicToken {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'clinicId')
  Clinic clinic;
  @JsonKey(name: 'userId')
  User? user;
  int? tokenNumber;
  TokenStatus tokenStatus;
  UserType userType;
  @JsonKey(fromJson: utcToLocal)
  DateTime createdAt;
  @JsonKey(fromJson: utcToLocal)
  DateTime updatedAt;
  String? userName;
  bool get isOnline {
    return userType == UserType.ONLINE;
  }

  ClinicToken(
      {required this.id,
      required this.clinic,
      required this.createdAt,
      required this.tokenStatus,
      required this.updatedAt,
      required this.userType,
       this.tokenNumber,
      this.userName,
      this.user});

  factory ClinicToken.fromJson(Map<String, dynamic> json) => _$ClinicTokenFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicTokenToJson(this);
}
