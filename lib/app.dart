import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/logger/observers.dart';
import 'package:flutter_firebase_template/providers/fcm_provider.dart';
import 'package:flutter_firebase_template/providers/fcm_token_provider.dart';
import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:flutter_firebase_template/providers/navigator_key_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    useEffect(() => fcmService.listenToMessages(), [fcmService]);
    useEffect(() => fcmTokenService?.tokenSync(), [fcmTokenService]);

    final firebaseAnalytics = ref.watch(firebaseAnalyticsProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [
          MainAppNavigationObserver(),
          if (firebaseAnalytics != null)
            FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
        ],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      theme: MainAppTheme().build(),
    );
  }
}
