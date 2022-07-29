import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:flutterfire_ui/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SignInScreen(
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
