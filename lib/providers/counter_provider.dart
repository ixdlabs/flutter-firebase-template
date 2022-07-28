import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = StateProvider<int>((ref) {
  return 0;
}, name: "counterProvider");
