# Flutter Project

## Running Project

It is recommended to use `fvm` to run the project. You can install `fvm` by following the instructions [here](https://fvm.app/).
If you have `fvm` installed, you can run the following command,

```shell
fvm use
fvm flutter run
```

## Design Choices

### State Management

The project uses [Riverpod](https://riverpod.dev/) to manage the state of the application.
The relevant provider code is in `lib/providers` directory.
Additionally, [Flutter Hooks] (https://pub.dev/packages/flutter_hooks) are used for manage life cycle of the widgets.

### Routing

This project uses [Auto Route](https://pub.dev/packages/auto_route) to handle routing.
The relevant code is in `lib/router` directory.
Since this routing package is using code generation, you will have to run `build_runner` everytime routing code is changed.

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Common Widgets

All common widgets live inside `lib/widgets` directory.

### Pages

All pages live inside `lib/pages` directory.
Each page should be inside directories that represent their feature/use-case.

### Logging

The project uses [Logger](https://pub.dev/packages/logger) to log the events.
Logging can be done simply as `Log.d("message")` (for debug) or `Log.i("message")` (for info) or `Log.w("message")` (for warning) or `Log.e("message")` (for error). You may also pass an `Exception` and a `StackTrace` to log the error as `Log.e("message", e, stackTrace)`.

Note: If the logs are crowded with `ViewPostIme` logs, apply following filter (VS Code): `!ViewPostIme`
