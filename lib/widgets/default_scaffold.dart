import "package:flutter/material.dart";
import "package:flutter/services.dart";

class DefaultScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  const DefaultScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Override following to change the status bar color.
      // statusBarColor is the background color of the status bar.
      // statusBarIconBrightness is the brightness of the status bar icons.
      value: SystemUiOverlayStyle(
        statusBarColor: theme.primaryColorDark,
        statusBarIconBrightness: theme.brightness,
      ),
      child: Container(
        color: theme.primaryColorDark,
        child: SafeArea(
          child: Scaffold(
            appBar: appBar,
            backgroundColor: theme.scaffoldBackgroundColor,
            body: body,
            floatingActionButton: floatingActionButton,
          ),
        ),
      ),
    );
  }
}
