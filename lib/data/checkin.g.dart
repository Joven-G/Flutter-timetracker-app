// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckIn _$CheckInFromJson(Map<String, dynamic> json) {
  return CheckIn(
      json['id'] as String,
      json['day'] == null ? null : DateTime.parse(json['day'] as String),
      json['elapsed'] as int,
      json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String));
}

Map<String, dynamic> _$CheckInToJson(CheckIn instance) => <String, dynamic>{
      'id': instance.id,
      'day': instance.day?.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'elapsed': instance.elapsed
    };
