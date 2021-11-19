import 'package:json_annotation/json_annotation.dart';
part 'user_address_model.g.dart';

@JsonSerializable()
class UserAddress {
  String? address;
  String? apartment;
  String? city;
  String? pincode;
  @JsonKey(fromJson: coordinatesFromJson, name: "geometry")
  List<double>? coordinates;

  UserAddress({this.address, this.apartment, this.coordinates, this.pincode, this.city});

  factory UserAddress.fromJson(Map<String, dynamic> json) => _$UserAddressFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressToJson(this);
}

List<double>? coordinatesFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;

  print(json);
  return [json["coordinates"][0].toDouble(), json["coordinates"][1].toDouble()];
}
