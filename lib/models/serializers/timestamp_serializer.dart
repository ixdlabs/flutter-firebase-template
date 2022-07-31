import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// A custom JSON converter that allows conversion between
/// [Timestamp] and [DateTime].
/// Any [DateTime] in the model will be converted to
/// [Timestamp] if this converter is applied.
class TimestampConverter extends JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp json) {
    return json.toDate();
  }

  @override
  Timestamp toJson(DateTime object) {
    return Timestamp.fromDate(object);
  }
}
