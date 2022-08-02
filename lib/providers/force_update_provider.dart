import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/providers/remote_config_provider.dart';
import 'package:flutter_firebase_template/utils/version_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A service provider that provides whether the app requires
/// a forced update or not.
final forceUpdateProvider = FutureProvider<bool>((ref) async {
  try {
    if (!kReleaseMode) return false;
    final remoteConfig = ref.watch(remoteConfigProvider);
    if (remoteConfig == null) return false;

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final minimumAppVersion = await remoteConfig.minimumAppVersion;
    return minimumAppVersion.hasHigherVersionThan(currentVersion);
  } catch (e, st) {
    Log.e("Something went wrong while checking for force update", e, st);
    return false;
  }
}, name: "force_update_provider");
