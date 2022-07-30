import 'package:flutter/material.dart';

typedef ValueBuilder<T> = Widget Function(T);

extension SnapshotBuilder<T> on AsyncSnapshot<T> {
  Widget when({
    required Widget Function(T) onData,
    Widget Function(Object?)? onError,
    Widget Function()? onLoading,
  }) {
    if (hasError) {
      return onError == null ? Text("Error: $error") : onError(error);
    } else if (connectionState != ConnectionState.waiting && hasData) {
      return onData(data as T);
    }
    return onLoading == null
        ? const DefaultSnapshotLoadingWidget()
        : onLoading();
  }
}

class DefaultSnapshotLoadingWidget extends StatelessWidget {
  const DefaultSnapshotLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
