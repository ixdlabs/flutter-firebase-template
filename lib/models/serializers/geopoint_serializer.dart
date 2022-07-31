import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/models/location.dart';
import 'package:json_annotation/json_annotation.dart';

/// A custom JSON converter that allows conversion between
/// [GeoPoint] and a custom class.
class GeoPointConverter extends JsonConverter<GeoLocation, GeoPoint> {
  const GeoPointConverter();

  @override
  GeoLocation fromJson(GeoPoint json) {
    return GeoLocation(json.latitude, json.longitude);
  }

  @override
  GeoPoint toJson(GeoLocation object) {
    return GeoPoint(object.latitude, object.longitude);
  }
}
