import 'dart:ffi';

import 'package:booktokenclinicapp/utils/date_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'plan_model.g.dart';

@JsonSerializable()
class PlanModel {
  @JsonKey(name: '_id')
  String id;
  double amount;
  int duration;
  bool isMonthly;
  String currency;

  @JsonKey(fromJson: utcToLocal)
  DateTime createdAt;
  @JsonKey(fromJson: utcToLocal)
  DateTime updatedAt;

  PlanModel(

      {
        required this.id,
        required this.amount,
      required this.currency,
      required this.duration,
      required this.isMonthly,
      required this.createdAt,
      required this.updatedAt});

  factory PlanModel.fromJson(Map<String, dynamic> json) => _$PlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanModelToJson(this);
}
