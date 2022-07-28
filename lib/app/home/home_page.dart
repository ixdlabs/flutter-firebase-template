import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/providers/counter_provider.dart';
import 'package:flutter_firebase_template/widgets/default_scaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return DefaultScaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(child: Text("Counter: $counter")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state = counter + 1,
        child: const Icon(Icons.add),
      ),
    );
  }
}
