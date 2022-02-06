import 'dart:ffi';

import 'package:skipq_clinic/constants/globals.dart';
import 'package:skipq_clinic/models/subscription_model/plan_model.dart';
import 'package:skipq_clinic/utils/date_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionModel {
  @JsonKey(name: '_id')
  String clinic;
  PlanModel plan;

  SubscriptionType subscriptionType;

  @JsonKey(fromJson: utcToLocal)
  DateTime createdAt;
  @JsonKey(fromJson: utcToLocal)
  DateTime updatedAt;
  @JsonKey(fromJson: utcToLocal)
  DateTime subStartDate;
  @JsonKey(fromJson: utcToLocal)
  DateTime subEndDate;

  SubscriptionModel(
      {required this.clinic,
      required this.plan,
      required this.createdAt,
      required this.subEndDate,
      required this.subStartDate,
      required this.subscriptionType,
      required this.updatedAt});

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}
