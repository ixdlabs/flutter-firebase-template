import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/theme.dart';
import 'package:logging/logging.dart';

void main() {
  if (kReleaseMode) {
    // Don't log anything below warnings in production.
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) async {
    debugPrint("${record.level.name}: ${record.time}: "
        "${record.loggerName}: "
        "${record.message}");
    if (record.error != null) {
      debugPrint("${record.error}");
      debugPrint("${record.stackTrace}");
    }
    if (record.level == Level.SEVERE) {
      // TODO: Capture exception
    }
  });

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MainAppTheme().build(),
    );
  }
}
