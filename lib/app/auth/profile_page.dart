import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body: ProfileScreen(
        auth: firebaseAuth,
        actions: [
          SignedOutAction((context) {
            Log.i("User signed out");
            context.router.replaceAll(const [LoginRoute()]);
          }),
        ],
        providerConfigs: const [EmailProviderConfiguration()],
      ),
    );
  }
}
