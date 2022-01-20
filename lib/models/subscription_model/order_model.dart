import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  String mid;
  String callbackUrl;
  String orderId;
  String txnToken;
  double ammount;


  OrderModel({required this.mid, required this.callbackUrl, required this.orderId, required this.txnToken, required this.ammount});

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}


