// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// An example firebase options file to make sure linters/tests will pass.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "exampleApiKey",
      appId: "exampleAppId",
      messagingSenderId: "exampleMessagingSenderId",
      projectId: "exampleProjectId",
      storageBucket: "exampleStorageBucket",
    );
  }
}
