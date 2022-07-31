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
    final messenger = Messenger.of(context);
    // Handles events from fCM service.
    // This logic lies here because we want FCM events to be handled only after logging in.
    useEffect(() {
      return ref.read(fcmServiceProvider).fcmEventStream.listen((event) {
        Log.i("FCM event: $event");
        messenger.showSuccess("FCM event: $event");
      }).cancel;
    }, [ref, messenger]);
    // Handles initial message.
    // This will be run only once but should come after listening to fCM events.
    // Otherwise, the message will not be handled by the listeners.
    useEffect(() {
      ref.read(fcmServiceProvider).handleInitialMessage();
      return null;
    }, []);

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
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Send myself a Notification"),
              onPressed: () {
                ref.read(fcmServiceProvider).sendSelfNotification(
                    "Hello World", "This is a test notification");
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
