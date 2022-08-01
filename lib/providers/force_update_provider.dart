import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_firebase_template/constants.dart';
import 'package:flutter_firebase_template/utils/version_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final forceUpdateProvider = FutureProvider((ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  final minimumAppVersion =
      remoteConfig.getString(RemoteConfigKeys.minimumAppVersion);

  return minimumAppVersion.hasHigherVersionThan(currentVersion);
}, name: "force_update_provider");
