import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/models/serializers/timestamp_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'count.g.dart';

@JsonSerializable()
@TimestampConverter()
class Count {
  final int count;
  final DateTime? lastUpdated;

  Count({required this.count, this.lastUpdated});

  factory Count.fromJson(Map<String, dynamic> json) => _$CountFromJson(json);

  Map<String, dynamic> toJson() => _$CountToJson(this);
}
