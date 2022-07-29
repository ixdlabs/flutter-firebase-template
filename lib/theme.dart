import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/constants.dart';

class MainAppTheme {
  ThemeData build() {
    return ThemeData(
      primarySwatch: ColorConstants.kPrimarySwatch,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(24),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      ),
    );
  }
}
