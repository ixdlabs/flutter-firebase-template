import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/models/count.dart';
import 'package:flutter_firebase_template/services/firestore_service.dart';

abstract class CountService extends FirestoreService<Count> {
  CountService({required super.collectionRef});

  Stream<Count?> getMyCount();

  Future<void> incrementMyCount();
}

class CountServiceImpl extends CountService {
  final User currentUser;

  CountServiceImpl({required super.collectionRef, required this.currentUser});

  @override
  Stream<Count?> getMyCount() {
    return documentStream(docId: currentUser.uid, docBuilder: Count.fromJson);
  }

  @override
  Future<void> incrementMyCount() async {
    try {
      final currentCount = await documentFuture(
          docId: currentUser.uid, docBuilder: Count.fromJson);
      await setData(
        docId: currentUser.uid,
        data: {
          'count': (currentCount?.count ?? 0) + 1,
          'lastUpdated': FieldValue.serverTimestamp()
        },
      );
    } catch (e, st) {
      Log.e("Error incrementing count", e, st);
      return Future.error(e);
    }
  }
}
