import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A singleton logger class.
/// Errors logs will be sent to crashlytics.
class Log {
  static late final Log _instance;
  final Logger logger;
  FirebaseCrashlytics? firebaseCrashlytics;
  FirebaseAnalytics? firebaseAnalytics;

  Log._({required this.logger});

  /// Initialize the logger.
  /// This method must be called before any other method.
  static Future<void> initialize() async {
    // Don't log anything below warnings in production.
    if (kReleaseMode) Logger.level = Level.warning;
    final logger = Logger(printer: _MainAppLogPrinter());
    _instance = Log._(logger: logger);
  }

  /// Set the firebase services to use.
  static void setFirebaseServices(
      {required FirebaseCrashlytics crashlytics,
      required FirebaseAnalytics analytics}) {
    _instance.firebaseCrashlytics = crashlytics;
    _instance.firebaseAnalytics = analytics;
    Log.i("Logging using firebase Crashlytics and Analytics.");
  }

  /// Logs a message at the [Level.verbose] level.
  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.logger.v(message, error, stackTrace);
  }

  /// Logs a message at the [Level.debug] level.
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.logger.d(message, error, stackTrace);
  }

  /// Logs a message at the [Level.info] level.
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.logger.i(message, error, stackTrace);
  }

  /// Logs a message at the [Level.warning] level.
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.logger.w(message, error, stackTrace);
  }

  /// Logs a message at the [Level.error] level.
  static void e(dynamic message,
      [dynamic error, StackTrace? stackTrace]) async {
    _instance.logger.e(message, error, stackTrace);
    await _instance.firebaseCrashlytics
        ?.recordError(error, stackTrace, reason: message);
  }

  /// Logs a message at the [Level.wtf] level.
  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.logger.wtf(message, error, stackTrace);
  }

  /// Logs a analytics event.
  static void a(String name, [Map<String, Object?>? parameters]) async {
    _instance.logger.i("Analytics [$name] Parameters:  $parameters");
    await _instance.firebaseAnalytics
        ?.logEvent(name: name, parameters: parameters);
  }
}

class _MainAppLogPrinter extends LogPrinter {
  final devPrinter = PrettyPrinter(
    methodCount: 0,
    stackTraceBeginIndex: 1,
    noBoxingByDefault: true,
  );

  @override
  List<String> log(LogEvent event) {
    if (!kReleaseMode) return devPrinter.log(event);
    return ["${event.level.name} [${DateTime.now()}]: ${event.message}"];
  }
}
