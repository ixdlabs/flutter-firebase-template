import 'package:flutter/material.dart';

/// Shows generic error widget, with possibility to add retry button below it.
class ErrorMessageWidget extends StatelessWidget {
  final String? message;
  final Object? exception;
  final VoidCallback? onRetry;

  const ErrorMessageWidget({
    super.key,
    this.message,
    this.exception,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: theme.errorColor,
              child: Icon(
                Icons.error_outline,
                color: theme.scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              message ?? exception?.toString() ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (onRetry != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onRetry,
              ),
          ],
        ),
      ),
    );
  }
}
