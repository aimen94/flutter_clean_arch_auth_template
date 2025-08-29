import 'package:json_annotation/json_annotation.dart';

part 'update_user_request_model.g.dart';

@JsonSerializable()
class UpdateUserRequestModel {
  String? firstName;
  String? lastName;
  UpdateUserRequestModel({this.firstName, this.lastName});

  factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserRequestModelToJson(this);
}
