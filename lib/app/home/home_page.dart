import 'package:auto_route/auto_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/providers/counter_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

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
            Text("Counter: $counter",
                style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Go to my Profile"),
              onPressed: () => context.pushRoute(const ProfileRoute()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state = counter + 1,
        child: const Icon(Icons.add),
      ),
    );
  }
}
