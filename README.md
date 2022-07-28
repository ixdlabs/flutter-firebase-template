# Flutter Project

## Running Project

It is recommended to use `fvm` to run the project. You can install `fvm` by following the instructions [here](https://fvm.app/).
If you have `fvm` installed, you can run the following command,

```shell
fvm use
fvm flutter run
```

## Configuration

### Enabled Services

1. Authentication https://firebase.flutter.dev/docs/auth/start
2. Firestore https://firebase.flutter.dev/docs/firestore/usage
3. Crashlytics https://firebase.flutter.dev/docs/crashlytics/usage

### Flutter setup

1. Enable firebase services.
2. Change application id in `android/app/build.gradle` to your application id. (Default `com.example.flutter_firebase_template`)
3. In iOS, change the bundle id to your application id. (Default `com.example.flutterFirebaseTemplate`)
4. Remove firebase files from `.gitignore`.
5. Install [`flutterfire`](https://firebase.flutter.dev/docs/overview/#using-the-flutterfire-cli).
6. Use `flutterfire configure` to configure the project. (Run this again if you change the application id/add new services)
7. Crash app using top right button and use dashboard to make sure crashlytics integration works.

> TODO: Guide on using emulator.

## Design Choices

### State Management

The project uses [Riverpod](https://riverpod.dev/) to manage the state of the application.
The relevant provider code is in `lib/providers` directory.
Additionally, [Flutter Hooks](https://pub.dev/packages/flutter_hooks) are used for manage life cycle of the widgets.

### Routing

This project uses [Auto Route](https://pub.dev/packages/auto_route) to handle routing.
The relevant code is in `lib/router` directory.
Since this routing package is using code generation, you will have to run `build_runner` everytime routing code is changed.

```shell
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
