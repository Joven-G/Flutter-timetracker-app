import 'package:json_annotation/json_annotation.dart';

part 'checkin.g.dart';

@JsonSerializable()
class CheckIn {
  CheckIn(this.id, this.day, this.elapsed, this.startTime);

  final String id;
  final DateTime day;
  final DateTime startTime;
  int elapsed;

  factory CheckIn.fromJson(Map<String, dynamic> json) => _$CheckInFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInToJson(this);
}
