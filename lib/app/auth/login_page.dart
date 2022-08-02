import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SignInScreen(
        auth: firebaseAuth,
        actions: [
          AuthStateChangeAction<SignedIn>((context, _) {
            Log.i("User signed in");
            context.router.replaceAll(const [HomeRoute()]);
          }),
        ],
        providerConfigs: const [EmailProviderConfiguration()],
      ),
    );
  }
}
