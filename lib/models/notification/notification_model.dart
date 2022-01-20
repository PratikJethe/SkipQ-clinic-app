import 'dart:ffi';

import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/utils/date_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(fromJson: utcToLocal)
  DateTime createdAt;
  @JsonKey(fromJson: utcToLocal)
  DateTime updatedAt;
  String title;
  String? subtitle;
  @JsonKey(name: 'clinicId')
  Clinic clinic;
  bool isSeen;

  NotificationModel(
      {required this.id,
      required this.isSeen,
      this.subtitle,
      required this.createdAt,
      required this.updatedAt,
      required this.title,
      required this.clinic});

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
