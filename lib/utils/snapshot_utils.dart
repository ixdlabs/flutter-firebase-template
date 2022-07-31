import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/widgets/error_widget.dart';
import 'package:flutter_firebase_template/widgets/loader_widget.dart';

typedef ValueBuilder<T> = Widget Function(T);

extension SnapshotUtils<T> on AsyncSnapshot<T> {
  /// Returns a [Widget] that displays the data of the snapshot.
  /// If the snapshot is loading, it will display a [LoaderWidget].
  Widget when({
    required ValueBuilder<T> onData,
    ValueBuilder<Object?>? onError,
    Widget Function()? onLoading,
  }) {
    if (hasError) {
      return onError == null
          ? ErrorMessageWidget(error: error)
          : onError(error);
    } else if (connectionState != ConnectionState.waiting && hasData) {
      return onData(data as T);
    }
    return onLoading == null ? const LoaderWidget() : onLoading();
  }
}
