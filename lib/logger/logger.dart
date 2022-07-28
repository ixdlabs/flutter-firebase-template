import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  static late Logger _logger;

  Log._();

  static Future<void> initialize() async {
    _logger = Logger(printer: _MainAppLogPrinter());
  }

  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  static void e(dynamic message,
      [dynamic error, StackTrace? stackTrace]) async {
    _logger.e(message, error, stackTrace);
    await FirebaseCrashlytics.instance
        .recordError(error, stackTrace, reason: message);
  }

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error, stackTrace);
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
