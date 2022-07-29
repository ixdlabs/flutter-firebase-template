import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/logger/logger.dart';

typedef DocumentBuilder<T> = T Function(Map<String, dynamic> data);
typedef DocumentWithIdBuilder<T> = T Function(
    Map<String, dynamic> data, String docId);
typedef QueryBuilder<T> = Query<Map<String, dynamic>> Function(
    Query<Map<String, dynamic>> query);

abstract class FirestoreService<T> {
  final CollectionReference<Map<String, dynamic>> collectionRef;

  FirestoreService({required this.collectionRef});

  Future<void> setData({
    required String docId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final docRef = collectionRef.doc(docId);
    Log.d("Setting data of ${docRef.path}: $data");
    await docRef.set(data, SetOptions(merge: merge));
  }

  Future<void> deleteData({required String docId}) async {
    final docRef = collectionRef.doc(docId);
    Log.d("Deleting data from ${docRef.path}");
    await docRef.delete();
  }

  /// Returns a stream of a collection in firestore.
  /// The stream will emit for each document in the collection.
  /// [queryBuilder] is a function that can be used to modify the query.
  Stream<List<T>> collectionStream({
    required DocumentWithIdBuilder<T> docBuilder,
    QueryBuilder<T>? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = collectionRef;
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => docBuilder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      return result;
    });
  }

  /// Returns a stream of documents that match the given document ID.
  /// If the document does not exist, the stream will emit null.
  Stream<T?> documentStream({
    required String docId,
    required DocumentBuilder<T> docBuilder,
  }) {
    final docRef = collectionRef.doc(docId);
    final snapshots = docRef.snapshots();
    return snapshots.map((snapshot) {
      final snapshotData = snapshot.data();
      if (snapshotData == null) return null;
      return docBuilder(snapshotData);
    });
  }

  /// Returns a single document that matches the given document ID.
  /// If the document does not exist, the future will complete with null.
  Future<T?> documentFuture({
    required String docId,
    required DocumentBuilder<T> docBuilder,
  }) async {
    final docRef = collectionRef.doc(docId);
    final docData = (await docRef.get()).data();
    if (docData == null) return null;
    return docBuilder(docData);
  }
}
