import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
    name: "auth_state_changes_provider");

final authCurrentUserProvider = Provider<User?>(
    (ref) => ref.watch(authStateChangesProvider).valueOrNull,
    name: "auth_current_user_provider");
