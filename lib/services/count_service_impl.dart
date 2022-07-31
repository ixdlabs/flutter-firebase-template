import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/models/count.dart';
import 'package:flutter_firebase_template/services/count_service.dart';
import 'package:flutter_firebase_template/services/firestore_service.dart';

class CountServiceImpl extends CountService with FirestoreService<Count> {
  final User currentUser;

  CountServiceImpl({required this.currentUser});

  @override
  Stream<Count?> getMyCount() {
    return documentStream(currentUser.uid, docBuilder: Count.fromJson);
  }

  @override
  Future<void> incrementMyCount() async {
    try {
      await createOrUpdate(currentUser.uid, createData: {
        'count': 1,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, updateData: {
        'count': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      Log.e("Error incrementing count", e, st);
    }
  }
}
