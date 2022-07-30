// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmToken _$FcmTokenFromJson(Map<String, dynamic> json) => FcmToken(
      tokens:
          (json['tokens'] as List<dynamic>).map((e) => e as String).toList(),
      lastUpdated: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['lastUpdated'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$FcmTokenToJson(FcmToken instance) => <String, dynamic>{
      'tokens': instance.tokens,
      'lastUpdated': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.lastUpdated, const TimestampConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
