import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:flutterfire_ui/auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: const ProfileScreen(
        providerConfigs: [EmailProviderConfiguration()],
      ),
    );
  }
}
