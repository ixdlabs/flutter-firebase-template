import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/models/count.dart';
import 'package:flutter_firebase_template/services/count_service.dart';
import 'package:flutter_firebase_template/services/firestore_service.dart';

class FirestoreCountService extends FirestoreService<Count> with CountService {
  final User currentUser;

  FirestoreCountService({
    required this.currentUser,
    required super.firebaseFirestore,
  });

  @override
  Stream<Count?> getMyCount() {
    return documentStream(currentUser.uid, docBuilder: Count.fromJson);
  }

  @override
  Future<void> incrementMyCount() async {
    try {
      await createOrUpdate(
        currentUser.uid,
        updateData: (currentData) => _updateIncrCount(currentData),
        createData: () => {
          'count': 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
      );
    } catch (e, st) {
      Log.e("Error incrementing count", e, st);
    }
  }

  Map<String, dynamic> _updateIncrCount(Map<String, dynamic>? currentData) {
    // Send every 10th increment to the analytics service.
    if (currentData != null) {
      final count = Count.fromJson(currentData);
      if (count.count % 10 == 9) {
        Log.a("count_incr_10", {'count': count.count});
      }
    }

    return {
      'count': FieldValue.increment(1),
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    return "FirestoreCountService(${currentUser.displayName})";
  }
}
