import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/models/fcm_token.dart';
import 'package:flutter_firebase_template/services/fcm_token_service.dart';
import 'package:flutter_firebase_template/services/firestore_service.dart';

class FirestoreFcmTokenService extends FirestoreService<FcmToken>
    with FcmTokenService {
  final User currentUser;
  StreamSubscription? _fcmOnTokenRefreshSubscription;

  FirestoreFcmTokenService({
    required this.currentUser,
    required super.firebaseFirestore,
  });

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
      await createOrUpdate(
        currentUser.uid,
        updateData: (currentData) => _updateFcmToken(currentData, token),
        createData: () => {
          'tokens': [token],
          'lastUpdated': FieldValue.serverTimestamp(),
        },
      );
    } catch (e, st) {
      Log.e("Error saving token", e, st);
    }
  }

  Map<String, dynamic>? _updateFcmToken(
      Map<String, dynamic>? currentData, String token) {
    // Don't update if the token is already in the list.
    if (currentData != null) {
      final fcmToken = FcmToken.fromJson(currentData);
      if (fcmToken.tokens.contains(token)) {
        return null;
      }
    }
    return {
      'tokens': FieldValue.arrayUnion([token]),
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  @override
  void stopTokenSync() {
    _fcmOnTokenRefreshSubscription?.cancel();
  }

  @override
  String toString() {
    return "FirestoreFcmTokenService(${currentUser.displayName})";
  }
}
