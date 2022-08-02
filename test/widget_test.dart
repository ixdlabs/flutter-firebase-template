// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_firebase_template/app.dart';
import 'package:flutter_firebase_template/app/auth/splash_page.dart';
import 'package:flutter_firebase_template/app/home/home_page.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils/mocked_provider_scope.dart';

void main() {
  setUp(() {
    Log.initialize();
  });

  testWidgets('Navigate to home page test', (WidgetTester tester) async {
    final firebaseAuth = MockFirebaseAuth();
    await firebaseAuth.signInWithEmailAndPassword(
        email: "email@example.com", password: "password");

    // Build our app and trigger a frame.
    await tester.pumpWidget(mockedProviderScope(
      mockFirebaseAuth: firebaseAuth,
      mockFirebaseFirestore: FakeFirebaseFirestore(),
      child: const MainApp(),
    ));

    // Should start at splash screen
    await tester.pump();
    expect(find.byType(SplashPage), findsOneWidget);

    // Should navigate to home page
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
}
