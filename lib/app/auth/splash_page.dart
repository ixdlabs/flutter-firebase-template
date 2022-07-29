import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = context.router;
    final authState = ref.watch(authStateChangesProvider);
    useEffect(() {
      if (authState.hasValue) {
        if (authState.value == null) {
          Log.i("User is not logged in, redirecting to login page");
          router.replaceAll(const [LoginRoute()]);
        } else {
          Log.i("User is logged in, redirecting to home page");
          router.replaceAll(const [HomeRoute()]);
        }
      }
      return null;
    }, [authState, router]);

    return const DefaultScaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
