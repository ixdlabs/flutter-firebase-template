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

This project uses `auto_route` to handle routing.
The relevant code is in `lib/router` directory.
Since this routing package is using code generation, you will have to run `build_runner` everytime routing changes.
Documentation for this package is [here](https://pub.dev/packages/auto_route).

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```
