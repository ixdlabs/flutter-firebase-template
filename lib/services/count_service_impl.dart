import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/models/count.dart';
import 'package:flutter_firebase_template/services/count_service.dart';

class CountServiceImpl extends CountService {
  final User currentUser;

  CountServiceImpl({
    required super.collectionRef,
    required this.currentUser,
  });

  @override
  Stream<Count?> getMyCount() {
    return documentStream(currentUser.uid, docBuilder: Count.fromJson);
  }

  @override
  Future<void> incrementMyCount() async {
    try {
      final docRef = collectionRef.doc(currentUser.uid);
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update(Count.updatedJson());
      } else {
        await docRef.set(Count.updatedJson(count: 1));
      }
    } catch (e, st) {
      Log.e("Error incrementing count", e, st);
      return Future.error(e);
    }
  }
}
