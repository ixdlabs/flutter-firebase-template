import 'package:auto_route/auto_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/providers/count_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultScaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () => FirebaseCrashlytics.instance.crash(),
            icon: const Icon(Icons.bug_report),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CountWidget(),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Go to my Profile"),
              onPressed: () => context.pushRoute(const ProfileRoute()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(countServiceProvider)?.incrementMyCount(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CountWidget extends ConsumerWidget {
  const CountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countNumber = ref.watch(countNumberProvider);

    return countNumber.when(
      data: (count) => Text("My count: ${count?.count}",
          style: Theme.of(context).textTheme.headline4),
      error: (error, st) =>
          Text("Error: $error", style: Theme.of(context).textTheme.headline4),
      loading: () =>
          Text("Loading...", style: Theme.of(context).textTheme.headline4),
    );
  }
}
