import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/firebase_options.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/logger/observers.dart';
import 'package:flutter_firebase_template/providers/fcm_provider.dart';
import 'package:flutter_firebase_template/providers/fcm_token_provider.dart';
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
    final appRouter = useMemoized(() => MainAppRouter(), []);

    // Eager initialization of global services.
    // If there are services are must be initialized at startup, put them here.
    // More Info: https://github.com/rrousselGit/riverpod/issues/202
    ref.watch(fcmServiceProvider);
    ref.watch(fcmTokenServiceProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [MainAppNavigationObserver()],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      theme: MainAppTheme().build(),
    );
  }
}
