
import 'package:json_annotation/json_annotation.dart';
part '.g.dart';

@JsonSerializable()
class  {
  final String id;
  final String name;

  ({
    required this.id,
    required this.name,
  });

  factory  .fromJson(Map<String, dynamic> json) => _$FromJson(json);
  Map<String, dynamic> toJson() => _$ToJson(this);
}

