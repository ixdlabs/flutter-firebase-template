import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/models/serializers/timestamp_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fcm_token.g.dart';

@JsonSerializable()
@TimestampConverter()
class FcmToken {
  final List<String> tokens;
  final DateTime? lastUpdated;

  FcmToken({required this.tokens, this.lastUpdated});

  factory FcmToken.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenFromJson(json);

  Map<String, dynamic> toJson() => _$FcmTokenToJson(this);

  @override
  String toString() {
    return 'FcmToken{tokens: $tokens}';
  }
}
