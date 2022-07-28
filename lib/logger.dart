import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

class MainAppLogger {
  static final MainAppLogger _instance = MainAppLogger._();
  static MainAppLogger get instance => _instance;

  MainAppLogger._();

  Future<void> onLogRecord(LogRecord record) async {
    debugPrint("${record.level.name}: ${record.time}: "
        "${record.loggerName}: ${record.message}");
    if (record.error != null) {
      debugPrint("Error:      ${record.error}");
      debugPrint("Stacktrace: ${record.stackTrace}");
    }
    if (record.level == Level.SEVERE) {
      // TODO: Capture exception
    }
  }

  ProviderObserver get providerObserver => _MainAppProviderObserver();
  AutoRouterObserver get navigatorObserver => _MainAppNavigationObserver();
}

class _MainAppProviderObserver extends ProviderObserver {
  final _logger = Logger('provider_observer');

  String getName(ProviderBase provider) {
    return provider.name ?? provider.runtimeType.toString();
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    _logger.info("${getName(provider)} updated to $newValue");
  }

  @override
  void providerDidFail(ProviderBase provider, Object error,
      StackTrace stackTrace, ProviderContainer container) {
    _logger.warning("Error from ${getName(provider)}: $error");
  }
}

class _MainAppNavigationObserver extends AutoRouterObserver {
  final _logger = Logger('navigation_observer');

  @override
  void didPush(Route route, Route? previousRoute) {
    _logger.info("Pushed ${route.settings.name}");
  }
}
