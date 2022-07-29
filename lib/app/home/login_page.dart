import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultScaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: const Center(child: Text("Login")),
    );
  }
}
