import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/models/fcm_token.dart';
import 'package:flutter_firebase_template/services/fcm_token_service.dart';

class FcmTokenServiceImpl extends FcmTokenService {
  final User currentUser;

  FcmTokenServiceImpl({
    required super.collectionRef,
    required this.currentUser,
  });

  @override
  Future<void> storeToken(String token) async {
    Log.i("Storing FCM token: $token");
    try {
      await createOrUpdate(currentUser.uid, createData: {
        'tokens': [token],
        'lastUpdated': FieldValue.serverTimestamp(),
      }, updateData: {
        'tokens': FieldValue.arrayUnion([token]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, skipUpdate: (data) {
        // Don't update if the token is already in the list.
        return FcmToken.fromJson(data).tokens.contains(token);
      });
    } catch (e, st) {
      Log.e("Error saving token", e, st);
    }
  }
}
