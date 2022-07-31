import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// An observer for [ProviderScope] that logs events happening for providers.
class MainAppProviderObserver extends ProviderObserver {
  String getName(ProviderBase provider) {
    return provider.name ?? provider.runtimeType.toString();
  }

  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    Log.d('Provider added: ${getName(provider)}');
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    Log.d("[${getName(provider)}] updated to $newValue");
  }

  @override
  void providerDidFail(ProviderBase provider, Object error,
      StackTrace stackTrace, ProviderContainer container) {
    Log.e("[${getName(provider)}] $error");
  }
}

/// An observer for [AutoRouter] that logs push events.
class MainAppNavigationObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    Log.d("Pushed Route ${route.settings.name}");
  }
}
