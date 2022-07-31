import 'package:auto_route/auto_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/providers/count_provider.dart';
import 'package:flutter_firebase_template/providers/fcm_provider.dart';
import 'package:flutter_firebase_template/router/router.gr.dart';
import 'package:flutter_firebase_template/utils/messenger/messenger.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Following will attach a listener to the FCM service.
    // When a message is received, the listener will call this closure.
    useEffect(() {
      return ref.read(fcmServiceProvider).subscribe((event) {
        Log.i("FCM event: $event");
        Messenger.of(context).showSuccess("FCM event: $event");
      });
    }, [ref, BuildContext]);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            tooltip: "Crash Me",
            onPressed: () => FirebaseCrashlytics.instance.crash(),
            icon: const Icon(Icons.error),
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
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Send myself a Notification"),
              onPressed: () {
                ref.read(fcmServiceProvider).showLocalNotification(
                  0,
                  title: "Hello World",
                  body: "This is a test notification",
                  data: {"test": "test"},
                );
              },
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
      data: (count) => Column(
        children: [
          Text("My count: ${count?.count ?? 0}",
              style: Theme.of(context).textTheme.headline4),
          const SizedBox(height: 8),
          if (count?.lastUpdated != null)
            Text("Last updated: ${count!.lastUpdated!.toIso8601String()}",
                style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
      error: (error, st) =>
          Text("Error: $error", style: Theme.of(context).textTheme.headline4),
      loading: () =>
          Text("Loading...", style: Theme.of(context).textTheme.headline4),
    );
  }
}
