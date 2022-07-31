import 'package:flutter_firebase_template/models/count.dart';
import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/services/count_service.dart';
import 'package:flutter_firebase_template/services/count_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final countServiceProvider = Provider.autoDispose<CountService?>((ref) {
  final currentUser = ref.watch(authCurrentUserProvider);
  if (currentUser == null) return null;
  return CountServiceImpl(currentUser: currentUser);
}, name: "count_service_provider");

final myCountProvider = StreamProvider.autoDispose<Count?>((ref) {
  final countService = ref.watch(countServiceProvider);
  if (countService == null) return const Stream.empty();
  return countService.getMyCount();
}, name: "count_number_provider");
