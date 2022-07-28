import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/logger.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

void main() {
  // Don't log anything below warnings in production.
  if (kReleaseMode) Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen(MainAppLogger.instance.onLogRecord);

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final _appRouter = MainAppRouter();
  final _appTheme = MainAppTheme();

  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [MainAppLogger.instance.providerObserver],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: _appRouter.delegate(
          navigatorObservers: () => [MainAppLogger.instance.navigatorObserver],
        ),
        routeInformationParser: _appRouter.defaultRouteParser(),
        theme: _appTheme.build(),
      ),
    );
  }
}
