extension VersionUtils on String {
  /// Returns whether the [newVersion] is greater than the string.
  /// The string is assumed to be of the format "x.x.x"(semver).
  bool hasHigherVersionThan(String newVersion) {
    List<String> currentV = split(".");
    List<String> newV = newVersion.split(".");
    for (var i = 0; i <= 2; i++) {
      final currentVInt = int.tryParse(currentV[i]) ?? 0;
      final newVInt = int.tryParse(newV[i]) ?? 0;
      if (currentVInt != newVInt) return newVInt > currentVInt;
    }
    return false;
  }
}
