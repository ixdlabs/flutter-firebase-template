import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/services/count_service_impl.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/services/fcm_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmServiceProvider = Provider<FcmService>((ref) {
  final fcmService = FcmServiceImpl(handlers: [DemoFcmHandler()]);
  fcmService.initialize();
  return fcmService;
}, name: "fcm_service_provider");
