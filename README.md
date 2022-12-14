# Flutter Project

## Out-of-the-box features/tools

- Router integration and simple page setup boilerplate
- Login/Register/Profile pages with Firebase Authentication
- Check for app updates to force update (using Firebase Remote Config)
- Logger that make logging easier and sends error logs to Firebase Crashlytics
- Firestore configuration and model/services structuring with helper methods
- FCM notifications with Firebase Messaging and Local Notifications integration that enables foreground and background notifications
- Sync FCM token with Firestore for the logged in users

## Running Project

It is recommended to use `fvm` to run the project. You can install `fvm` by following the
instructions [here](https://fvm.app/).
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
4. Cloud Messaging https://firebase.flutter.dev/docs/messaging/usage
5. Remote Config https://firebase.flutter.dev/docs/remote-config/overview
6. Analytics https://firebase.flutter.dev/docs/analytics/overview

### Project setup

1. Create a firebase project. No need to add any apps yet.
2. Install [`flutterfire`](https://firebase.flutter.dev/docs/overview/#using-the-flutterfire-cli). (Tested with version `0.2.4`)
3. Use `flutterfire configure` to configure the project and add android/iOS apps. (Run this again if you change the application id/add new services)
4. Run `configure.py` script using `python configure.py`. You may need to install python. Delete the `configure.py` file after running the script.  If something goes wrong  while running the script, reset the project using `git reset --hard` and try again.
5. Run `fvm flutter pub get` to install all the dependencies. 
6. Run the app. 
7. Crash app using top right button and use dashboard to make sure crashlytics integration works. 
8. Send a self notification to make sure local notifications integration works. 
9. Send a test notification via the dashboard (The FCM registration token will be logged in to the console) and check if
   it arrives (Both when app is in foreground/background). Tapping it should show a success message. 
10. Set and publish `minimumAppVersion` in Remote Config to 2.0.0 (higher than current), now when you open the app, there should be a message saying that you need to update the app.

Note: To rename the intellij project properly, use intellij refactoring.

### Firebase Local Setup/Use Emulators

1. Run `firebase init` in firebase project directory and enable services and emulators.
2.  You can deploy firebase project via `firebase deploy`. Use `firebase deploy --only firestore` to deploy firestore rules only.
3. Start emulators by `firebase emulators:start`.
4. In the app, set `DebugConstants.enableEmulators` to `true`.
5. Run the app in a android emulator in the same device as firebase emulators.
6. Now app should connect to firebase emulator.

## Design Choices

### State Management

The project uses [Riverpod](https://riverpod.dev/) to manage the state of the application.
The relevant provider code is in `lib/providers` directory.
Additionally, [Flutter Hooks](https://pub.dev/packages/flutter_hooks) are used for manage life cycle of the widgets.

### Models

The json models are in `lib/models` directory.
These will be generated using `build_runner`.
The models should not have any dependencies on other packages or any associated logic.

Code generator can be run by following command,

```shell
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Services

The services are in `lib/services` directory.
Each firebase service will extend `FirebaseService` class.
All query/write/delete methods will be implemented in the associated service class.
Each service will also accompany a abstract class (which defines the interface) and a implementation class.

### Providers

The providers are in `lib/providers` directory.

### Routing

This project uses [Auto Route](https://pub.dev/packages/auto_route) to handle routing.
The relevant code is in `lib/router` directory.
Since this routing package is using code generation, you will have to run `build_runner` everytime routing code is
changed.

### Common Widgets

All common widgets live inside `lib/widgets` directory.

Flutterfire UI is integrated. This includes several auth and firestore widgets.
See [Flutterfire UI Widget Catalogue](https://firebase.flutter.dev/docs/ui/widgets) for more details.

### Pages

All pages live inside `lib/pages` directory.
Each page should be inside directories that represent their feature/use-case.

### Logging

The project uses [Logger](https://pub.dev/packages/logger) to log the events.
Logging can be done simply as `Log.d("message")` (for debug) or `Log.i("message")` (for info) or `Log.w("message")` (for
warning) or `Log.e("message")` (for error). You may also pass an `Exception` and a `StackTrace` to log the error
as `Log.e("message", e, stackTrace)`.

Note: If the logs are crowded with unnecessary logs, apply following filter (VS Code): `I/flutter`

## Future Work

- [ ] Local Notifications Release
  Config (https://pub.dev/packages/flutter_local_notifications#release-build-configuration)
- [ ] iOS Configurations
