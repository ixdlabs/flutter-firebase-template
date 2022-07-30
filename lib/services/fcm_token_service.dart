import 'package:flutter_firebase_template/models/fcm_token.dart';
import 'package:flutter_firebase_template/services/firestore_service.dart';

abstract class FcmTokenService extends FirestoreService<FcmToken> {
  FcmTokenService({required super.collectionRef});

  Future<void> storeToken(String token);
}
