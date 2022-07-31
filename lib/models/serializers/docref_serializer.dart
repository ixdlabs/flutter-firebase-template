import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// A custom JSON converter that allows [DocumentReference] to stay in the json.
class DocRefConverter
    extends JsonConverter<DocumentReference, DocumentReference> {
  const DocRefConverter();

  @override
  DocumentReference fromJson(DocumentReference json) {
    return json;
  }

  @override
  DocumentReference toJson(DocumentReference object) {
    return object;
  }
}
