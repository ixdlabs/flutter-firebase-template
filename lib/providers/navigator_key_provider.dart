import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigatorKeyProvider = Provider((ref) {
  return GlobalKey<NavigatorState>();
});
