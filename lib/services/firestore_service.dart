import 'package:cloud_firestore/cloud_firestore.dart';

typedef DocumentBuilder<T> = T Function(Map<String, dynamic> data);
typedef DocumentWithIdBuilder<T> = T Function(
    Map<String, dynamic> data, String docId);
typedef QueryBuilder<T> = Query<Map<String, dynamic>> Function(
    Query<Map<String, dynamic>> query);

typedef DocDataEvaluator = bool Function(Map<String, dynamic> data);
typedef DocDataCreate = Map<String, dynamic>? Function();
typedef DocDataUpdate = Map<String, dynamic>? Function(
    Map<String, dynamic>? currentData);

abstract class FirestoreService<T> {
  FirebaseFirestore firebaseFirestore;

  String get collectionName;

  FirestoreService({required this.firebaseFirestore});

  CollectionReference<Map<String, dynamic>> get collectionRef =>
      firebaseFirestore.collection(collectionName);

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
  Stream<T?> documentStream(String docId,
      {required DocumentBuilder<T> docBuilder}) {
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
  Future<T?> documentFuture(String docId,
      {required DocumentBuilder<T> docBuilder}) async {
    final docRef = collectionRef.doc(docId);
    final docData = (await docRef.get()).data();
    if (docData == null) return null;
    return docBuilder(docData);
  }

  Future<void> createOrUpdate(
    String docId, {
    required DocDataCreate createData,
    required DocDataUpdate updateData,
  }) async {
    final docRef = collectionRef.doc(docId);
    final doc = await docRef.get();
    if (doc.exists) {
      final docData = doc.data();
      final updatedData = updateData(docData);
      if (updatedData != null) await docRef.update(updatedData);
    } else {
      final createdData = createData();
      if (createdData != null) await docRef.set(createdData);
    }
  }
}
