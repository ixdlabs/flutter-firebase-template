import 'package:flutter_firebase_template/models/count.dart';
import 'package:flutter_firebase_template/services/firestore_service.dart';

abstract class CountService extends FirestoreService<Count> {
  CountService({required super.collectionRef});

  Stream<Count?> getMyCount();

  Future<void> incrementMyCount();
}
