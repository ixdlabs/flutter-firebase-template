import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/models/fcm_token.dart';
import 'package:flutter_firebase_template/services/fcm_token_service.dart';
import 'package:flutter_firebase_template/services/firestore_service.dart';

class FcmTokenServiceImpl extends FcmTokenService
    with FirestoreService<FcmToken> {
  final User currentUser;
  StreamSubscription? _fcmOnTokenRefreshSubscription;

  FcmTokenServiceImpl({required this.currentUser});

  @override
  void startTokenSync() {
    // Store FCM token on firestore.
    // The first token as well as updates are stored in the same collection.
    FirebaseMessaging.instance.getToken().then(storeToken);
    _fcmOnTokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen(storeToken);
  }

  @override
  Future<void> storeToken(String? token) async {
    Log.i("Storing FCM token: $token");
    if (token == null) return;
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

  @override
  void dispose() {
    _fcmOnTokenRefreshSubscription?.cancel();
  }
}
