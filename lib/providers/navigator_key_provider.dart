import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A provider that provides navigator key.
final navigatorKeyProvider = Provider((ref) {
  return GlobalKey<NavigatorState>();
}, name: "navigator_key_provider");
