import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/services/count_service.dart';
import 'package:flutter_firebase_template/services/count_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final countServiceProvider = Provider<CountService?>((ref) {
  final currentUser = ref.watch(authCurrentUserProvider);
  if (currentUser == null) return null;
  return CountServiceImpl(
    collectionRef: FirebaseFirestore.instance.collection("counts"),
    currentUser: currentUser,
  );
}, name: "count_service_provider");
