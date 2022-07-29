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
    );
  }
}
