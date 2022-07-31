import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/constants.dart';
import 'package:flutter_firebase_template/firebase_options.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/logger/observers.dart';
import 'package:flutter_firebase_template/providers/fcm_provider.dart';
import 'package:flutter_firebase_template/providers/fcm_token_provider.dart';
import 'package:flutter_firebase_template/providers/force_update_provider.dart';
import 'package:flutter_firebase_template/providers/navigator_key_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

void main() async {
  // Don't log anything below warnings in production.
  if (kReleaseMode) Logger.level = Level.warning;
  await Log.initialize();

  // Initialize firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Log.i("Firebase app initialized.");
  // If variable is set, enable firebase emulators.
  if (DebugConstants.enableEmulators) {
    await FirebaseAuth.instance.useAuthEmulator(
        DebugConstants.emulatorHost, DebugConstants.emulatorAuthPort);
    FirebaseFirestore.instance.useFirestoreEmulator(
        DebugConstants.emulatorHost, DebugConstants.emulatorFirestorePort);
    Log.w("Running in emulator mode. Connected to emulators at "
        "${DebugConstants.emulatorHost}.");
  }

  // Remote Config
  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  Log.i("Remote Config initialized.");
  // Crashlytics
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Log.i("Crashlytics initialized.");
  // FCM
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  Log.i("FCM initialized.");

  runApp(const MainAppProvider());
}

class MainAppProvider extends StatelessWidget {
  const MainAppProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [MainAppProviderObserver()],
      child: const MainApp(),
    );
  }
}

class MainApp extends HookConsumerWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    final appRouter =
        useMemoized(() => MainAppRouter(navigatorKey), [navigatorKey]);

    // These services will be reset when service changes.
    // Note: We cannot move the startup logic to providers since
    // they may not get initialized if there are no listeners.
    final fcmService = ref.watch(fcmServiceProvider);
    final fcmTokenService = ref.watch(fcmTokenServiceProvider);
    useEffect(() => fcmService.listenToMessages, [fcmService]);
    useEffect(() => fcmTokenService?.tokenSync, [fcmTokenService]);

    // Show the force update dialog if the app is updated.
    final forceUpdate = ref.watch(forceUpdateProvider);
    useEffect(() {
      if (forceUpdate.valueOrNull ?? false) {
        Log.w("Force update requested.");
        final context = navigatorKey.currentContext;
        if (context == null) return;
        showForceUpdateDialog(context);
      }
      return null;
    }, [forceUpdate, navigatorKey]);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [MainAppNavigationObserver()],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      theme: MainAppTheme().build(),
    );
  }

  void showForceUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Force update"),
        content: const Text("A new version of the app is available."),
        actions: [
          TextButton(
            child: const Text("Update"),
            onPressed: () {
              Log.i("Redirecting to app store.");
            },
          ),
        ],
      ),
    );
  }
}
