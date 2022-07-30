import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
    (ref) => FirebaseAuth.instance,
    name: "firebase_auth_provider");

final authStateChangesProvider = StreamProvider.autoDispose<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
    name: "auth_state_changes_provider");

final authCurrentUserProvider = Provider.autoDispose<User?>(
    (ref) => ref.watch(firebaseAuthProvider).currentUser,
    name: "auth_current_user_provider");
