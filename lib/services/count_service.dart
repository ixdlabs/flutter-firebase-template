import 'package:flutter_firebase_template/constants.dart';
import 'package:flutter_firebase_template/models/count.dart';

abstract class CountService {
  Stream<Count?> getMyCount();

  Future<void> incrementMyCount();

  String get collectionName => CollectionNames.counts;
}
