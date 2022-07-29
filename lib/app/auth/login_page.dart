import 'package:flutter/material.dart';
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
      body: const SignInScreen(
        providerConfigs: [EmailProviderConfiguration()],
      ),
    );
  }
}
