import 'package:flutter_firebase_template/constants.dart';

abstract class FcmTokenService {
  Future<void> storeToken(String token);

  String get collectionName => CollectionNames.fcmTokens;
}
