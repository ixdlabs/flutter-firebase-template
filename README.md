# Flutter Project

## Running Project

It is recommended to use `fvm` to run the project. You can install `fvm` by following the instructions [here](https://fvm.app/).
If you have `fvm` installed, you can run the following command,

```shell
fvm use
fvm flutter run
```

## Generating Code using build_runner

If you pull the project from GitHub, oryou need to run the following command,

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```
