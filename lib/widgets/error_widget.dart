import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final Object? error;

  const ErrorMessageWidget({Key? key, required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Error: $error"),
      ),
    );
  }
}
